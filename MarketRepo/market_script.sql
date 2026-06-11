/* Drop Tables Script
	DROP TABLE PayoutItem;
	DROP TABLE Payout;
	DROP TABLE PaymentEvent;
	DROP TABLE Payment;
	DROP TABLE OrderItem;
	DROP TABLE OrderSnapshotAddress;
	DROP TABLE ProductOrder;
	DROP TABLE ProductCategory;
	DROP TABLE Category;
	DROP TABLE PostMedia;
	DROP TABLE ProductPost;
	DROP TABLE ProductMedia;
	DROP TABLE Product;
	DROP TABLE UserBookmark;
	DROP TABLE PostComment;
	DROP TABLE PostLike;
	DROP TABLE Post;
	DROP TABLE Follow;
	DROP TABLE Shop;
	DROP TABLE UserAddress;
	DROP TABLE UserProfile;
	DROP TABLE UserAccount;
*/
/* AUTHENTICATION NOTE

		This project is intended to use Supabase Auth.

		Supabase's auth.users table may replace the custom AuthUser table defined in the logical data model.

		The AuthUser table written below for documentation purposes 
		and for future migration to a custom authentication solution if decided on.
*/
/*
	CREATE TABLE AuthUser
	(
		authUserID UUID NOT NULL,
		userID UUID NOT NULL,
		passwordHash TEXT NULL,
		provider VARCHAR(50) NOT NULL,
		providerUserID TEXT NULL,
		emailVerified BOOLEAN NOT NULL DEFAULT FALSE,
		lastLoginAt TIMESTAMPTZ NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_authuser_authuserid
			PRIMARY KEY(authUserID),
		CONSTRAINT fk_authuser_user
			FOREIGN KEY (userID)
				REFERENCES UserAccount(userID)
				ON DELETE CASCADE,
		CONSTRAINT uq_provider_provideruserID
			UNIQUE (provider, providerUserID)
	);

*/

-- CREATE TABLES --

	CREATE TABLE UserAccount
	(
		userID UUID NOT NULL,
		username VARCHAR(50) NOT NULL,
		displayName VARCHAR(50) NOT NULL,
		email VARCHAR(255) NOT NULL,
		status VARCHAR(20) NOT NULL CHECK(status IN ('active', 'inactive', 'suspended', 'review-pending', 'banned')),
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,

		CONSTRAINT pk_useraccount_userid
			PRIMARY KEY (userID),
		CONSTRAINT uq_useraccount_email
			UNIQUE(email)
	);

	CREATE TABLE UserProfile
	(
		userID UUID NOT NULL,
		firstName VARCHAR(100) NOT NULL,
		lastName VARCHAR(100) NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,

		CONSTRAINT pk_userprofile_userid
			PRIMARY KEY (userID),
		CONSTRAINT fk_userprofile_useraccount
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID) 
			ON DELETE CASCADE

	);
	
	CREATE TABLE UserAddress
	(
		userAddressID UUID NOT NULL,
		userID UUID NOT NULL,
		street VARCHAR(100) NULL,
		city VARCHAR(100) NULL,
		province VARCHAR(100) NULL,
		postalCode VARCHAR(20) NULL,
		country CHAR(2) NULL,
		isDefaultShipping BOOLEAN NULL,
		isDefaultBilling BOOLEAN NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,

		CONSTRAINT pk_useraddress_useraddressid
			PRIMARY KEY (userAddressID),
		CONSTRAINT fk_useraddress_user
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID) 
			ON DELETE CASCADE
	);
	
	CREATE TABLE Shop
	(
		shopID UUID NOT NULL,
		userID UUID UNIQUE NOT NULL,
		shopName VARCHAR(100) NOT NULL,
		shopDescription TEXT NOT NULL,
		status VARCHAR(20) NOT NULL CHECK(status IN ('active', 'inactive', 'review-pending', 'suspended', 'banned')),
		stripeAccountID TEXT NOT NULL,
		isVerified BOOLEAN NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,

		CONSTRAINT pk_shop_shopid
			PRIMARY KEY (shopID),
		CONSTRAINT fk_shop_user
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID) 
			ON DELETE CASCADE
	);
	
	CREATE TABLE Follow
	(
		followerUserID UUID NOT NULL,
		followingUserID UUID NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,
		
		CONSTRAINT pk_followeruserid_followinguserid
			PRIMARY KEY (followerUserID, followingUserID),
		CONSTRAINT fk_followeruserid_useraccount
			FOREIGN KEY (followerUserID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE,
		CONSTRAINT fk_followinguserid_useraccount
			FOREIGN KEY (followingUserID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE,
		CONSTRAINT ck_follow_not_self
    		CHECK (followerUserID <> followingUserID)
	);

	CREATE TABLE Post
	(
		postID UUID NOT NULL,
		shopID UUID NULL,
		userID UUID NOT NULL,
		caption VARCHAR(500) NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,

		CONSTRAINT pk_post_postid
			PRIMARY KEY (postID),
		CONSTRAINT fk_post_shop
			FOREIGN KEY (shopID)
			REFERENCES Shop(shopID)
			ON DELETE CASCADE,
		CONSTRAINT fk_post_useracccount
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE
	);

	CREATE TABLE PostLike
	(
		userID UUID NOT NULL,
		postID UUID NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,

		CONSTRAINT pk_postlike_userid_postid
			PRIMARY KEY (userID, postID),
		CONSTRAINT fk_postlike_useraccount
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE,
		CONSTRAINT fk_postlike_post
			FOREIGN KEY (postID)
			REFERENCES Post(postID)
			ON DELETE CASCADE
	);

	CREATE TABLE PostComment
	(
		commentID UUID NOT NULL,
		postID UUID NOT NULL,
		userID UUID NOT NULL,
		postContent TEXT NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,
		
		CONSTRAINT pk_postcomment_commentID
			PRIMARY KEY (commentID),
		CONSTRAINT fk_postcomment_post
			FOREIGN KEY (postID)
			REFERENCES Post(postID)
			ON DELETE CASCADE,
		CONSTRAINT fk_postcomment_useraccount
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE
	);

	CREATE TABLE UserBookmark
	(
		postID UUID NOT NULL,
		userID UUID NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		
		CONSTRAINT pk_userbookmark_userid_postid
			PRIMARY KEY (userID, postID),
		CONSTRAINT fk_userbookmark_post
			FOREIGN KEY (postID)
			REFERENCES Post(postID)
			ON DELETE CASCADE,
		CONSTRAINT fk_userbookmark_useraccount
			FOREIGN KEY (userID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE
	);

	CREATE TABLE Product
	(
		productID UUID NOT NULL,
		shopID UUID NOT NULL,
		productTitle VARCHAR(255) NOT NULL,
		productDescription TEXT NOT NULL,
		productPrice NUMERIC(10,2) NOT NULL CHECK(productPrice >= 0),
		currency CHAR(3) NOT NULL,
		downloadLimit INT NULL CHECK(downloadLimit >= 0),
		status VARCHAR(20) NOT NULL CHECK(status IN ('draft', 'active-listing', 'paused-listing', 'review-pending', 'suspended')),
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		deletedAt TIMESTAMPTZ NULL,
		searchVector TSVECTOR NULL,

		CONSTRAINT pk_product_productid
			PRIMARY KEY(productID),
		CONSTRAINT fk_product_shop
			FOREIGN KEY (shopID)
			REFERENCES Shop(shopID)
			ON DELETE CASCADE
	);

	CREATE TABLE ProductMedia
	(
		productMediaID UUID NOT NULL,
		productID UUID NOT NULL,
		mediaType VARCHAR(20) NOT NULL,
		mediaURL TEXT NOT NULL,
		displayOrder INT NOT NULL CHECK(displayOrder >= 0),
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_productmedia_productmediaid
			PRIMARY KEY(productMediaID),
		CONSTRAINT fk_productmedia_product
			FOREIGN KEY (productID)
			REFERENCES Product(productID)
			ON DELETE CASCADE
	);

	CREATE TABLE ProductPost
	(
		postID UUID NOT NULL,
		productID UUID NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_productpost_postid_productid
			PRIMARY KEY (postID, productID),
		CONSTRAINT fk_productpost_post
			FOREIGN KEY (postID)
			REFERENCES Post(postID)
			ON DELETE CASCADE,
		CONSTRAINT fk_productpost_product
			FOREIGN KEY (productID)
			REFERENCES Product(productID)
			ON DELETE CASCADE
	);

	CREATE TABLE PostMedia
	(
		mediaID UUID NOT NULL,
		postID UUID NOT NULL,
		mediaType VARCHAR(20) NOT NULL CHECK(mediaType IN ('image', 'video', 'gif')),
		mediaURL TEXT NOT NULL,
		displayOrder INT NOT NULL CHECK(displayOrder >= 0),
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		
		CONSTRAINT pk_postmedia_mediaid
			PRIMARY KEY (mediaID),
		CONSTRAINT fk_postmedia_post
			FOREIGN KEY (postID)
			REFERENCES Post(postID)
			ON DELETE CASCADE
	);
	
	CREATE TABLE Category
	(
		categoryID UUID NOT NULL,
		categoryName VARCHAR(100) UNIQUE NOT NULL,
		slug VARCHAR(100) UNIQUE NOT NULL,

		CONSTRAINT pk_category_categoryID
			PRIMARY KEY(categoryID)
	);

	CREATE TABLE ProductCategory
	(
		productID UUID NOT NULL,
		categoryID UUID NOT NULL,

		CONSTRAINT pk_productcategory_productid_categoryid
			PRIMARY KEY (productID, categoryID),
		CONSTRAINT fk_productcategory_product
			FOREIGN KEY (productID)
			REFERENCES Product(productID)
			ON DELETE CASCADE,
		CONSTRAINT fk_productcategory_category
			FOREIGN KEY (categoryID)
			REFERENCES Category(categoryID)
			ON DELETE CASCADE
	);

	CREATE TABLE ProductOrder
	(
		orderID UUID NOT NULL,
		buyerUserID UUID NOT NULL,
		status VARCHAR(20) NOT NULL CHECK(status IN ('pending', 'paid', 'refunded', 'cancelled', 'failed')),
		subtotal NUMERIC(10,2) NOT NULL CHECK(subtotal >= 0),
		tax NUMERIC(10,2) NOT NULL CHECK(tax >= 0),
		totalAmount NUMERIC(10,2) NOT NULL CHECK(totalAmount >= 0),
		processingFee NUMERIC(10,2) NOT NULL CHECK(processingFee >= 0),
		currency CHAR(3) NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
		completedAt TIMESTAMPTZ NULL,
		
		CONSTRAINT pk_productorder_orderid
			PRIMARY KEY (orderID),
		CONSTRAINT fk_productorder_useraccount
			FOREIGN KEY (buyerUserID)
			REFERENCES UserAccount(userID)
	);

	CREATE TABLE OrderSnapshotAddress
	(
		orderAddressID UUID NOT NULL,
		orderID UUID NOT NULL,
		addressType VARCHAR(20) NOT NULL CHECK(addressType IN ('shipping', 'billing')),
		firstName VARCHAR(100) NOT NULL,
		lastName VARCHAR(100) NOT NULL,
		street VARCHAR(100) NULL,
		city VARCHAR(100) NULL,
		province VARCHAR(100) NULL,
		postalCode VARCHAR(20) NULL,
		country CHAR(2) NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_ordersnapshotaddress_orderaddressid
			PRIMARY KEY (orderAddressID),
		CONSTRAINT fk_ordersnapshotaddress_productorder
			FOREIGN KEY (orderID)
			REFERENCES ProductOrder(orderID)
			ON DELETE CASCADE
	);

	CREATE TABLE OrderItem
	(
		orderItemID UUID NOT NULL,
		orderID UUID NOT NULL,
		productID UUID NOT NULL,
		sellerUserID UUID NOT NULL,
		shopID UUID NOT NULL,
		productName VARCHAR(255) NOT NULL,
		price NUMERIC(10,2) NOT NULL CHECK(price >= 0),
		quantityOnOrder INT NOT NULL CHECK(quantityOnOrder >= 0),
		shopNameSnapshot VARCHAR(100) NOT NULL,
		sellerDisplayNameSnapshot VARCHAR(50) NOT NULL,
		
		CONSTRAINT pk_orderitem_orderitemid
			PRIMARY KEY (orderItemID),
		CONSTRAINT fk_orderitem_productorder
			FOREIGN KEY (orderID)
			REFERENCES ProductOrder(orderID),
		CONSTRAINT fk_orderitem_product
			FOREIGN KEY (productID)
			REFERENCES Product(productID),
		CONSTRAINT fk_orderitem_shop
			FOREIGN KEY (shopID)
			REFERENCES Shop(shopID),
		CONSTRAINT fk_orderitem_useraccount
			FOREIGN KEY (sellerUserID)
			REFERENCES UserAccount(userID)
	);

	CREATE TABLE Payment
	(
		paymentID UUID NOT NULL,
		orderID UUID UNIQUE NOT NULL,
		provider VARCHAR(50) NOT NULL,
		providerPaymentID TEXT NOT NULL,
		paymentIntentID TEXT NOT NULL,
		grossAmount NUMERIC(10,2) NOT NULL CHECK(grossAmount >= 0),
		netAmount NUMERIC(10,2) NOT NULL CHECK(netAmount >= 0),
		currency CHAR(3) NOT NULL,
		status VARCHAR(20) NOT NULL CHECK(status IN ('pending', 'paid', 'refunded', 'cancelled', 'failed')),
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_payment_paymentid
			PRIMARY KEY (paymentID),
		CONSTRAINT fk_payment_order
			FOREIGN KEY (orderID)
			REFERENCES ProductOrder(orderID)
	);

	CREATE TABLE PaymentEvent
	(
		paymentEventID UUID NOT NULL,
		paymentID UUID NOT NULL,
		eventType VARCHAR(50) NOT NULL,
		eventStatus VARCHAR(20) NULL CHECK(eventStatus IN ('pending', 'paid', 'refunded', 'cancelled', 'failed')),
		eventAmount NUMERIC(10,2) NULL CHECK(eventAmount >= 0), 
		currency CHAR(3) NULL,
		platformFee NUMERIC(10,2) NULL CHECK(platformFee >= 0),
		processingFee NUMERIC(10,2) NULL CHECK(processingFee >= 0),
		failureCode TEXT NULL,
		failureReason TEXT NULL,
		providerEventID TEXT NULL,
		idempotencyKey TEXT UNIQUE NULL,
		metadata JSONB NULL,
		createdAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,
	
		CONSTRAINT pk_paymentevent_paymenteventid
			PRIMARY KEY(paymentEventID),
		CONSTRAINT fk_paymentevent_payment
			FOREIGN KEY (paymentID)
			REFERENCES Payment(paymentID)
			ON DELETE CASCADE
	);

	CREATE TABLE Payout
	(
		payoutID UUID NOT NULL,
		shopID UUID NOT NULL,
		provider VARCHAR(50) NOT NULL,
		providerPayoutID TEXT NULL,
		totalPayoutAmount NUMERIC(10,2) NOT NULL CHECK(totalPayoutAmount >= 0),
		currency CHAR(3) NOT NULL,
		status VARCHAR(20) NOT NULL CHECK(status IN ('pending', 'scheduled', 'processing', 'paid', 'failed', 'reversed')),
		availableAt TIMESTAMPTZ NULL,
		initiatedAt TIMESTAMPTZ NULL,
		completedAt TIMESTAMPTZ NULL,
		failedAt TIMESTAMPTZ NULL,
		failureReason TEXT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_payout_payoutid
			PRIMARY KEY(payoutID),
		CONSTRAINT fk_payout_shop
			FOREIGN KEY (shopID)
			REFERENCES Shop(shopID)
	);

	CREATE TABLE PayoutItem
	(
		payoutID UUID NOT NULL,
		orderItemID UUID NOT NULL,
		payoutAmount NUMERIC(10,2) NOT NULL CHECK(payoutAmount >= 0),
		currency CHAR(3) NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_payoutitem_payoutid_orderitemid
			PRIMARY KEY (payoutID, orderItemID),
		CONSTRAINT fk_payoutitem_payout
			FOREIGN KEY (payoutID)
			REFERENCES Payout(payoutID)
			ON DELETE CASCADE,
		CONSTRAINT fk_payoutitem_orderitem
			FOREIGN KEY (orderItemID)
			REFERENCES OrderItem(orderItemID)
			ON DELETE CASCADE	
	);


-- INDEXES --

	CREATE INDEX idx_payout_shopid ON Payout(shopID);
	CREATE INDEX idx_post_userid ON Post(userID);
	CREATE INDEX idx_post_shopid ON Post(shopID);
	CREATE INDEX idx_postcomment_postid ON PostComment(postID);
	CREATE INDEX idx_postlike_postid ON PostLike(postID);
	CREATE INDEX idx_userbookmark_postid ON UserBookmark(postID);
	CREATE INDEX idx_product_shopid ON Product(shopID);
	CREATE INDEX idx_orderitem_orderid ON OrderItem(orderID);
	CREATE INDEX idx_orderitem_shopid ON OrderItem(shopID);
	CREATE INDEX idx_orderitem_selleruserid ON OrderItem(sellerUserID);
	
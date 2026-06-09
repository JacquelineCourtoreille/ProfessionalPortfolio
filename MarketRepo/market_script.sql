-- Database: MarketDB

DROP DATABASE IF EXISTS "MarketDB";

CREATE DATABASE "MarketDB"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Canada.1252'
    LC_CTYPE = 'English_Canada.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

	CREATE TYPE useraccount_status AS ENUM
	(
		'active',
		'suspended',
		'review-pending',
		'banned'
	);

	CREATE TYPE shop_status AS ENUM
	(
		'active',
		'active-temporary-pause',
		'suspended',
		'review-pending',
		'banned'
	);
	
	CREATE TYPE order_status AS ENUM 
	(
		'pending',
		'paid',
		'refunded',
		'cancelled',
		'failed'
	);

	CREATE TYPE product_status AS ENUM
	(
		'draft',
		'active-listing',
		'paused-listing',
		'out-of-stock',
		'review-pending',
		'suspended'
	);
	
	CREATE TYPE payment_status AS ENUM
	(
		'pending',
		'paid',
		'refunded',
		'cancelled',
		'failed'
	);

	CREATE TYPE payout_status AS ENUM
	(
		'pending',
		'scheduled',
		'processing',
		'paid',
		'failed',
		'reversed'
	);
	
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

	CREATE TABLE UserAccount
	(
		userID UUID NOT NULL,
		username VARCHAR(50) NOT NULL,
		displayName VARCHAR(50) NOT NULL,
		email VARCHAR(255) NOT NULL,
		status useraccount_status NOT NULL,
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
		status shop_status NOT NULL,
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
			ON DELETE CASCADE
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
		productPrice MONEY NOT NULL CHECK(productPrice >= 0),
		currency CHAR(3) NOT NULL,
		downloadLimit INT NULL CHECK(downloadLimit >= 0),
		status product_status NOT NULL,
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
		displayOrder INT UNIQUE NOT NULL CHECK(displayOrder >= 0),
		createdAt TIMESTAMPTZ NOT NULL,
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
		displayOrder INT UNIQUE NOT NULL CHECK(displayOrder >= 0),
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
		status order_status NOT NULL,
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
			ON DELETE CASCADE
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
			REFERENCES ProductOrder(orderID)
			ON DELETE CASCADE,
		CONSTRAINT fk_orderitem_product
			FOREIGN KEY (productID)
			REFERENCES Product(productID)
			ON DELETE CASCADE,
		CONSTRAINT fk_orderitem_shop
			FOREIGN KEY (shopID)
			REFERENCES Shop(shopID)
			ON DELETE CASCADE,
		CONSTRAINT fk_orderitem_useraccount
			FOREIGN KEY (sellerUserID)
			REFERENCES UserAccount(userID)
			ON DELETE CASCADE
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
		status payment_status NOT NULL,
		createdAt TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMPTZ NULL DEFAULT CURRENT_TIMESTAMP,

		CONSTRAINT pk_payment_paymentid
			PRIMARY KEY (paymentID),
		CONSTRAINT fk_payment_order
			FOREIGN KEY (orderID)
			REFERENCES ProductOrder(orderID)
			ON DELETE CASCADE
	);

	CREATE TABLE PaymentEvent
	(
		paymentEventID UUID NOT NULL,
		paymentID UUID NOT NULL,
		eventType VARCHAR(50) NOT NULL,
		eventStatus payment_status NULL,
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
		status payout_status NOT NULL,
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
			ON DELETE CASCADE
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
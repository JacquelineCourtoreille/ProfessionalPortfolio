using System;
using System.Collections.Generic;
using System.Text;

namespace MarketSolution
{
	public class UserAccount
	{
		#region Data Members
		private int _userID;
		private string _username;
		private string _displayName;
		private string _email;
		//Add enum for user status
		private UserShopStatus _status;
		private DateTime _createdAt;
		private DateTime? _updatedAt;
		private DateTime? _deletedAt;
		#endregion

		#region Properties
		public int UserID { get; private set; }
		public string Username { get; private set; }
		public string DisplayName { get; private set; }
		public string Email { get; private set; }
		public UserShopStatus Status { get; private set; }
		public DateTime CreatedAt { get; private set; }
		public DateTime? UpdatedAt { get; private set; } //Nullable DateTime, doesn't update on creation so this is nullable
		public DateTime? DeletedAt { get; private set; } //Nullable DateTime, this should not be set unless soft delete is called, so this is nullable
		#endregion

		#region Constructors
		/// <summary>
		/// This is the default constructor, it will take in all of the data members needed to instantiate the class and provides default values. 
		/// </summary>
		public UserAccount()
		{
			UserID = 0;
			Username = "Unknown";
			DisplayName = "Unknown";
			Email = "unknown@email.com";
			Status = UserShopStatus.active;
			CreatedAt = DateTime.Today;
			UpdatedAt = null;
			DeletedAt = null;
		}
		#endregion

		#region Methods

		#endregion
	}
}

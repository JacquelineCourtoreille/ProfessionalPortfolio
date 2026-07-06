using System;
using System.Collections.Generic;
using System.Text;

namespace MarketSolution
{
	public class Category
	{
		#region Data Members
		private string _categoryName;
		private string _slug;
		#endregion

		#region Properties
		public string CategoryName
		{
			get { return _categoryName; }
			//Business Rule: Category Name is required; cannot be null or empty.
			set
			{
				//Category Name is required
				if (string.IsNullOrWhiteSpace(value))
				{
					throw new ArgumentNullException("Category Name must be provided.");
				}
				_categoryName = value.Trim();
			}
		}
		public string Slug
		{
			get { return _slug; }
			//Business Rule: slug cannot be empty or null.
			set
			{
				//slug is required
				if (string.IsNullOrWhiteSpace(value))
				{
					throw new ArgumentNullException("Slug must be provided.");
				}
				_slug = value.Trim();
			}
		}

		#endregion

		#region Constructors
		/// <summary>
		/// This is the default constructor.
		/// Takes in both data members and provides default values.
		/// </summary>
		public Category()
		{
			CategoryName = "Unknown";
			Slug = "Unknown";
		}

		public Category(string categoryName, string slug)
		{
			//Setting the parameters | Property = parameter


			CategoryName = categoryName;
			Slug = slug;


		}
		#endregion

		#region Methods

		#endregion
	}
}

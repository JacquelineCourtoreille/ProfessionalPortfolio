using FluentAssertions;
using MarketSolution;

namespace UnitTestsForMarket
{
	public class Category_Should
	{
		#region Valid Data
		/// <summary>
		/// This test is for the Category default constructor.
		/// It tests for the default values, checking if the provided values for CategoryName and Slug are 
		/// set properly when creating an instance of the Category class.
		/// </summary>
		[Fact]
		public void Create_Instance_Using_Default_Constructor()
		{
			//Arrange
			string expectedCategoryName = "Unknown";
			string expectedSlug = "Unknown";

			//Action
			//sut: Subject Under Test
			Category sut = new();

			//Assertions (test evaluation)
			sut.CategoryName.Should().Be(expectedCategoryName);
			sut.Slug.Should().Be(expectedSlug);

		}

		/// <summary>
		/// This is the test for the Category Greedy Constructor
		/// It takes in all of the data members needed to instantiate the class.
		/// Checking that all of the parameter values are being set properly when creating an instance of the Category class.
		/// </summary>
		/// <param name="categoryName">Category Name</param>
		/// <param name="slug">Slug</param>
		[Fact]
		public void Create_Instance_Using_Greedy_Constructor()
		{
			//Arrange
			string categoryName = "Unknown";
			string slug = "Unknown";

			//Expectations
			string expectedCategoryName = "Unknown";
			string expectedSlug = "Unknown";

			//Act
			Category sut = new Category(categoryName, slug);

			//Assertions (test evaluation)
			sut.CategoryName.Should().Be(expectedCategoryName);
			sut.Slug.Should().Be(expectedSlug);
		}

		//Testing Fully Implemented Properties (Public Sets)
		//[Fact]

		[Fact]
		public void Change_Slug()
		{
			//Arrange
			string categoryName = "Unknown";
			string slug = "Unknown";
			Category sut = new(categoryName, slug);
			string newSlug = "crochet-slug";

			//Expected
			string expectedSlug = "crochet-slug";

			//Act
			sut.Slug = newSlug;

			//Assert
			sut.Slug.Should().Be(expectedSlug);
		}

		#endregion

		#region Invalid Data
		/// <summary>
		/// This test is testing bad data. It's trying to pass in null, empty, and whitespace values.
		/// The test will pass if these values throw an argument null exception.
		/// </summary>
		/// <param name="categoryName">Category Name</param>
		[Theory]
		[InlineData(null)]
		[InlineData("")]
		[InlineData("    ")]
		public void Create_New_Greedy_Instance_Throws_CategoryName_Exception(string categoryName)
		{
			//Arrange
			//string categoryName = "Unknown";
			string slug = "Unknown";

			//Act
			Action sut = () => new Category(categoryName, slug);

			//Assert
			sut.Should().Throw<ArgumentNullException>();
		}

		[Theory]
		[InlineData(null)]
		[InlineData("")]
		[InlineData("    ")]
		public void Create_New_Greedy_Instance_Throws_Slug_Exception(string slug)
		{
			//Arrange
			string categoryName = "Unknown";
			//string slug = "Unknown";

			//Act
			Action sut = () => new Category(categoryName, slug);

			//Assert
			sut.Should().Throw<ArgumentNullException>();
		}
		#endregion
	}
}

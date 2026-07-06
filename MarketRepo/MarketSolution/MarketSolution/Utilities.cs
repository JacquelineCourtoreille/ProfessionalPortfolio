using System;
using System.Collections.Generic;
using System.Text;

namespace MarketSolution
{
	public static class Utilities
	{
		//This utilities class contains methods used throught the program.

		/// <summary>
		/// IsPositive method validates the positivity of the integer value passed in. 
		/// Primarily being used to validate table IDs that are also primary keys.
		/// </summary>
		/// <param name="value">Primary Keys that are IDs</param>
		/// <returns>
		/// positive returns true
		/// negative returns false (will throw excption in the parent class)
		/// </returns>
		public static bool IsPositive(int value) => value > 0;
	}
}

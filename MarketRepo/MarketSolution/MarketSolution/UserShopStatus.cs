using System;
using System.Collections.Generic;
using System.Text;

namespace MarketSolution
{
	public enum UserShopStatus
	{
		/// <summary>
		/// The is enum is used in UserAccount class and Shop class.
		/// In the transition document, they are represented as two separate transition states. 
		/// To reduce redundancy the two transition state workflows have been combined into one enum.
		/// Transition state workflows: 
		///			active → reviewPending → suspended → banned → deleted
		///			active → inactive
		/// </summary>
		/// 

		active, //0
		inactive, //1
		reviewPending,
		suspended,
		banned,
		deleted
	}
}

//
//  StringExtensions.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 12/7/20.
//

import Foundation

extension String {
	subscript(offset: Int) -> Character {
		self[index(startIndex, offsetBy: offset)]
	}
	subscript(r: Range<Int>) -> Substring {
		let start = index(startIndex, offsetBy: r.startIndex)
		let end = index(startIndex, offsetBy: r.endIndex)
		let range = start ..< end
		return self[range]
	}
}

//
//  Optional+Extensions.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 06.02.2025.
//

import Foundation

extension Optional where Wrapped == String {
	var orEmpty: String {
		self ?? .empty
	}

	func orEmpty(_ defaultValue: String) -> String {
		if let self, self.isEmpty {
			return defaultValue
		}
		return self ?? defaultValue
	}
}

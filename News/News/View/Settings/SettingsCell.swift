//
//  SettingsCell.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI

struct SettingsCell: View, ImageProvider {
	@ObservedObject private var viewModel: ViewModel
	@State private var scale: CGFloat
	private let id: String
	
	init(
		viewModel: ViewModel,
		scale: CGFloat = 1.0,
		id: String
	) {
		self.viewModel = viewModel
		self.scale = scale
		self.id = id
	}
	
	var body: some View {
		HorStack(spacing: Constants.padding) {
			getImage(for: id)
				.padding(.leading, Constants.padding)
			Text(id.capitalizingFirstLetter())
				.font(.headline)
				.frame(maxHeight: .infinity, alignment: .leading)
			Spacer()
		}
		.card()
		.frame(height: 70)
		.applyOrNotSettingsModifier(
			isEnabled: viewModel.checkIsEnabled(id.lowercased()),
			scale: $scale
		) {
			viewModel.applySettings(id.lowercased())
		}
		.markIsSelected(viewModel, id)
	}
}

#Preview {
	SettingsCell(viewModel: ViewModel(), id: Category.business.rawValue)
}

//
//  InnerShadowProvider.swift
//  News
//
//  Created by Ярослав Куприянов on 04.02.2025.
//

import SwiftUI

struct InnerShadowProvider<S: Shape>: ViewModifier {
	private let radius: CGFloat = 2
	private let shape: S
	private let colors: [Color]
	private let width: CGFloat

	init(
		shape: S = .rect(cornerRadius: Constants.cornerRadius),
		colors: [Color] = [.blue, .indigo, .red, .cyan, .blue],
		width: CGFloat = 6
	) {
		self.shape = shape
		self.colors = colors
		self.width = width
	}

	func body(content: Content) -> some View {
		content
			.overlay(
				ZStack {
					shape
						.stroke(AngularGradient(colors: colors, center: .center), lineWidth: width)
						.offset(x: 2, y: -1.5)
						.blur(radius: radius * 7)
						.mask(shape)

					ForEach(0..<2) { _ in
						shape
							.stroke(AngularGradient(colors: colors, center: .center), lineWidth: width)
							.offset(x: 2, y: -1.5)
							.blur(radius: radius * 3)
							.mask(shape)
					}

					ForEach(0..<3) { _ in
						shape
							.stroke(AngularGradient(colors: colors, center: .center), lineWidth: width)
							.blur(radius: radius)
							.mask(shape)
					}

					ForEach(0..<7) { _ in
						shape
							.stroke(.white, lineWidth: 1.0)
							.blur(radius: 1.2)
							.mask(shape)
					}
				}
			)
	}
}

//
//  ContentView.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
	@Environment(ViewModel.self) private var viewModel
	@Environment(\.modelContext) var modelContext

	@Query private var savedSettings: [SettingsModel]
	@State private var imageWrapper: ContentWrapper?
	@State private var needOpenSettings = false

	var body: some View {
		TipView(SettingsTip())
			.padding()

		NavigationStack {
			TopicsList(viewModel: viewModel)
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						NavigationLink {
							SettingsList(viewModel: viewModel)
						} label: {
							Image(systemName: "gearshape.fill")
						}
					}

					ToolbarItem(placement: .principal) {
						DesignedText(text: Texts.Screen.Main.title())
							.font(.title)
					}

					ToolbarItem(placement: .topBarTrailing) {
						Image(systemName: "checkmark.seal.fill")
							.onTapGesture {
								viewModel.markAllAsRead()
							}
					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.sheet(item: $imageWrapper,
					   content: { content in
					ActivityViewController(contentWrapper: content)
						.presentationDetents([.medium])
				})
				.navigationDestination(isPresented: $needOpenSettings,
									   destination: {
					SettingsList(viewModel: viewModel)
				})
		}
		.onAppear { onAppear() }
		.onReceive(viewModel.$shareShortcutItemTapped) { needShare in
			guard needShare else { return }
			self.imageWrapper = ContentWrapper(link: .empty, description: DeveloperInfo.shareInfo)
		}
		.onReceive(viewModel.$settingsShortcutItemTapped) { needOpen in
			guard needOpen else { return }
			needOpenSettings.toggle()
		}
		.task {
			try? Tips.configure([
				.displayFrequency(.immediate),
				.datastoreLocation(.applicationDefault)
			])
		}
	}
}

// MARK: - Helpers & Settings
private extension ContentView {
	func onAppear() {
		loadSettings()
		viewModel.loadNews()
		viewModel.configureNotifications()
	}

	func loadSettings() {
		if savedSettings.isEmpty {
			let defaultSettings = [
				SettingsModel(
					category: Category.business.rawValue,
					soundTheme: SoundTheme.silentMode.rawValue,
					loader: LoaderConfiguration.hourGlass.rawValue,
					appIcon: AppIconConfiguration.globe.rawValue
				)
			]
			modelContext.insert(defaultSettings[0])
			try? modelContext.save()

			viewModel.savedSettings = defaultSettings
		} else {
			viewModel.savedSettings = savedSettings
		}

		viewModel.redrawContentViewLoader()
	}
}

#Preview {
	ContentView()
		.modelContainer(for: SettingsModel.self, inMemory: true)
}

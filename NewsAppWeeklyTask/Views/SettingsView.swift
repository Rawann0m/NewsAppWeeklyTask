//
//  SettingsView.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false
}
//settings page will have the dark mode toggle
struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $settingsViewModel.isDarkMode)
                .padding()
                .accessibilityHint("Toggles dark mode for better visibility")
        }.preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
    }
}
#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}

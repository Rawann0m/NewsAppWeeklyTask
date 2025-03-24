//
//  ContentView.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedView: String? = nil
        @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var isMenuOpen = false
        
    var body: some View {
        NavigationStack {
                    // Display the selected view
                    Group {
                        if selectedView == "Home" {
                            HomeView(settingsViewModel: settingsViewModel)
                        } else if selectedView == "Category" {
                            CategorySelectionView(settingsViewModel: settingsViewModel)
                        } else if selectedView == "Settings" {
                            SettingsView(settingsViewModel: settingsViewModel)
                        } else {
                            HomeView(settingsViewModel: settingsViewModel) // Default view
                        }
                    }
                    .navigationTitle(selectedView ?? "Home")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation { isMenuOpen.toggle() }
                            }) {
                                Image(systemName: "line.horizontal.3")
                            }
                        }
                    }
                }
                .overlay(
                    isMenuOpen ? SideMenuView(isMenuOpen: $isMenuOpen, settingsViewModel: settingsViewModel, selectedView: $selectedView) : nil,
                    alignment: .leading
                )
            }
        }

        struct SideMenuView: View {
            @Binding var isMenuOpen: Bool
            @ObservedObject var settingsViewModel: SettingsViewModel
            @Binding var selectedView: String? // Binding to control navigation
            
            var body: some View {
                VStack(alignment: .leading) {
                    // Home Button
                    Button(action: {
                        selectedView = "Home" // Navigate to Home
                        withAnimation { isMenuOpen = false } // Close the drawer
                    }) {
                        Label("Home", systemImage: "house")
                            .padding()
                            .foregroundColor(.primary)
                    }
                    
                    // Category Button
                    Button(action: {
                        selectedView = "Category" // Navigate to Category
                        withAnimation { isMenuOpen = false }
                    }) {
                        Label("Category", systemImage: "list.bullet")
                            .padding()
                            .foregroundColor(.primary)
                    }
                    
                    // Settings Button
                    Button(action: {
                        selectedView = "Settings" // Navigate to Settings
                        withAnimation { isMenuOpen = false } 
                    }) {
                        Label("Settings", systemImage: "gear")
                            .padding()
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
#Preview {
    ContentView()
}

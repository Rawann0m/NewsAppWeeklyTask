//
//  CategoryView.swift
//  NewsAppWeeklyTask
//
//  Created by Rawan on 22/09/1446 AH.
//
import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var selectedCategory: String = "Business"
    
    // List of categories
    let categories = ["Business", "Technology", "Finance", "Automotive"]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Category Picker
                Picker("Select a Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented) // the picker style
                .padding()
                
                // Display articles for the selected category
                CategoryNewsView(category: selectedCategory, settingsViewModel: settingsViewModel)
            }
            .navigationTitle("News")
        }
        .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
    }
}

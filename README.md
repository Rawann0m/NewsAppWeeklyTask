# NewsApp Weekly Task

## Overview
A modern iOS news application built with SwiftUI that fetches and displays news articles from various categories. The app implements MVVM architecture, supports dark mode, and features pagination with both URLSession and Alamofire implementations.

## Features
Multi-source News Fetching: Retrieves news from multiple API endpoints

Pagination: "Load More" functionality for infinite scrolling

Category Filtering: Browse news by Technology, Business, Finance, etc.

Dark Mode Support: Automatic theme switching based on system settings

Error Handling: User-friendly error messages for failed requests

Article Details: Full article view with "Read More" option

## Technical Implementation
Architecture
MVVM Pattern: Clean separation of concerns

SwiftUI: Modern declarative UI framework

## Key Components
NewsViewModel: Manages news data and business logic

ArticleRow: Reusable component for displaying articles

SettingsViewModel: Handles user preferences (dark mode)

## Usage
Home Screen: Shows latest headlines with infinite scroll

Categories: Tap the menu to browse by category

Article Details: Tap any article to view full content

Dark Mode: Toggle in Settings or use system setting

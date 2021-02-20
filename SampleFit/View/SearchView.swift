//
//  SearchView.swift
//  SampleFit
//
//  Created by Zihan Qi on 2/12/21.
//

import SwiftUI
import Combine

struct SearchView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject private var searchState = SearchState()
    @State private var exerciseSearchResults: [Exercise] = []
    @State private var userSearchResults: [PersonalInformation] = []
    var searchCancellable: AnyCancellable?
    
    var body: some View {
        NavigationViewWithSearchBar(text: $searchState.searchText, placeholder: "Videos, Users", scopes: SearchScope.allCases, tokenEventController: userData.searchCategoryTokenController) {
            
            SearchContent(searchState: searchState)
                .navigationTitle("Search")
            
        } onBegin: {
            searchState.isSearching = true
        } onCancel: {
            searchState.isSearching = false
        } onSearchClicked: {
            searchState.beginSearch()
        } onScopeChange: { newScope in
            searchState.scope = newScope
            if newScope == .user {
                userData.searchCategoryTokenController.removeAllTokens()
            }
            searchState.beginSearch()
        } onTokenItemsChange: { newTokenItems in
            searchState.searchCategory = newTokenItems.map { $0 as! Exercise.Category }.first ?? nil
            searchState.beginSearch()
        }

    }
    
}

struct SearchContent: View {
    @ObservedObject var searchState: SearchState
    
    var body: some View {
        VStack {
            if searchState.isSearching {
                if searchState.showsSuggestedSearch  {
                    SearchRecommendation(searchState: searchState)
                    
                } else {
                    SearchResult(searchState: searchState)
                    
                }
                
            } else {
                // MARK: Not searching - default view
            }
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var userData = UserData()
    @State private static var text = ""
    static var scope: SearchScope = .video
    static var previews: some View {
        Group {
            MultiplePreview(embedInNavigationView: false) {
                SearchView()
            }
        }
        .environmentObject(userData)
    }
}

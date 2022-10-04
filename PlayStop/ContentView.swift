//
//  ContentView.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 17/09/2022.
//

import SwiftUI
import IGDB_SWIFT_API

struct Game: Identifiable {
    let id: UInt64
    var name: String
}

struct ContentView: View {
    @State var games: [Game] = []
    @State var text: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter the name", text: $text).onChange(of: text) { newValue in
                testSearch(query: text)
            }
            ForEach(games) { game in
                Text(game.name)
            }
        }
        .onAppear {
            
            IGDBClient.postAuthentification(completion: handlePostAuthentification(success:error:))
        }
            
    }
    
    func handlePostAuthentification(success: Bool, error: Error?) {
        if success {
            print(IGDBClient.clientID, IGDBClient.Auth.accessToken)
            
        }
    }
    
    func testSearch(query: String) {
        let query = APICalypse()
            .search(searchQuery: query)
            .fields(fields: "game.*")
            .where(query: "game != n & game.version_parent = n")

        IGDBClient.wrapper.search(apiCalypse: query, result: { search in
            games = []
            for singleSearch in search {
                games.append(Game(id: singleSearch.id, name: singleSearch.game.name))
            }
        }) { error in
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

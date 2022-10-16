//
//  ContentView.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 17/09/2022.
//

import SwiftUI
import IGDB_SWIFT_API

struct prevGame: Identifiable {
    let id: UInt64
    var name: String
}

struct Game: Identifiable {
    let id: UInt64
    var name: String
    var coverUrl: String
    
}

struct ContentView: View {
    @State private var games: [Game] = []
    @State private var prevGames: [prevGame] = []
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List(games) { game in
                HStack {
                    AsyncImage(url: URL(string: game.coverUrl)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100)
                    } placeholder: {
                        ProgressView()
                    }

                    Text(game.name)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText) { value in
                Task {
                    await testSearch(value: value)
                }
            }
        }
        .navigationTitle("Games")
        .onAppear {
            IGDBClient.postAuthentification(completion: handlePostAuthentification(success:error:))
        }
    }
    
    func handlePostAuthentification(success: Bool, error: Error?) {
        if success {
            print(IGDBClient.clientID, IGDBClient.Auth.accessToken)
            
        }
    }
    
    func testSearch(value: String) async {
        if !value.isEmpty && value.count > 3 {
            let query = APICalypse()
                .search(searchQuery: value)
                .fields(fields: "game.*")
                .where(query: "game != n & game.version_parent = n")
            
            IGDBClient.wrapper.search(apiCalypse: query, result: { search in
                for singleSearch in search {
                    prevGames.append(prevGame(id: singleSearch.game.id, name: singleSearch.game.name))
                }
            }) { error in
                
            }
            
            for game in prevGames {
                let query = APICalypse()
                    .fields(fields: "image_id")
                    .where(query: "image_id != n & game.version_parent = n & game = \(game.id)")
                print(game.name)
                IGDBClient.wrapper.covers(apiCalypse: query, result: { covers in
                    if (covers.count > 0) {
                        games.append(Game(id: game.id, name: game.name, coverUrl: imageBuilder(imageID: covers[0].imageID, size: .COVER_SMALL)))
                    }
                }) { error in

                }
            }
        }
        else {
            prevGames.removeAll()
            games.removeAll()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

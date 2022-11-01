//
//  ContentView.swift
//  PlayStop
//
//  Created by mathusan selvakumar on 17/09/2022.
//

import SwiftUI
import IGDB_SWIFT_API

struct ContentView: View {
    @State private var games: [Game] = []
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List(games.sorted(by: { $0.name.compare($1.name, options: .caseInsensitive) == .orderedSame })) { game in
                HStack {
                    AsyncImage(url: game.coverURL!) { image in
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
                testSearch(value: value) { result in
                    switch result {
                        case .success(let games):
                            self.games = games
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
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

    func testSearch(value: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        if !value.isEmpty && value.count > 3 {
            
            let query = APICalypse()
                .fields(fields: "*, cover.image_id")
                .search(searchQuery: value)
                .where(query: "cover.image_id != n;")
            
            IGDBClient.wrapper.games(apiCalypse: query) { results in
                let games = results.map {Game(game: $0) }
                DispatchQueue.main.async {
                    completion(.success(games))
                }
            } errorResponse: { error in
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
        else {
            games.removeAll()
        }
    }
}

fileprivate extension Game {
    
    init(game: Proto_Game, coverSize: ImageSize = .COVER_BIG) {
        let coverURL = imageBuilder(imageID: game.cover.imageID, size: coverSize, imageType: .PNG)
        
        let screenshotURLs = game.screenshots.map { (scr) -> String in
            let url = imageBuilder(imageID: scr.imageID, size: .SCREENSHOT_MEDIUM, imageType: .JPEG)
            return url
        }
        
        let company = game.involvedCompanies.first?.company.name ?? ""
        let genres = game.genres.map { $0.name }
        self.init(id: Int(game.id),
                  name: game.name,
                  storyline: game.storyline,
                  summary: game.summary,
                  releaseDate: game.firstReleaseDate.date,
                  rating: game.rating,
                  coverURLString: coverURL, screenshotURLsString: screenshotURLs, genres: genres, company: company)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

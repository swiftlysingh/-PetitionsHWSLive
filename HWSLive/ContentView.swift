//
//  ContentView.swift
//  HWSLive
//
//  Created by Pushpinder Pal Singh on 02/08/21.
//

import SwiftUI

extension URLSession {
	func decode<T: Decodable> (
		_ type : T.Type = T.self,
		from url : URL
	) async throws -> T {
		let (data, _) = try await data(from: url)

		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	}
}

struct ContentView: View {

	@State private var petitions = [Petition]()

    var body: some View {
		NavigationView{
			List(petitions) { petition in
				Text(petition.title)
			}
			.navigationTitle("Petitions")
			.task {
				do{
					petitions = try await fetchData()
				}
				catch {
					print(error.localizedDescription)
				}
			}
		}
    }

	func fetchData() async throws -> [Petition] {
		let data = try await URLSession.shared.decode([Petition].self, from: URL(string: "https://www.hackingwithswift.com/samples/petitions.json")!)
		return data.sorted{ $0.signatureCount > $1.signatureCount}
	}
}

struct Petition: Codable, Identifiable {
	let id: String
	let title: String
	let body: String
	let deadline: Date
	let created: Date
	let signatureCount : Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}

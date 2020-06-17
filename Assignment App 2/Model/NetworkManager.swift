//
//  NetworkManager.swift
//  Assignment App 2
//
//  Created by Roman Kavinskyi on 17.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate {
	func didUpdateData(_ networkManager: NetworkManager, person: [PersonModel])
	func didFailWithError(error: Error)
}

struct NetworkManager {
	
	let baseURL = "https://5eba40143f971400169923ef.mockapi.io/person?limit=10&page="
	var page = 1
	
	var delegate: NetworkManagerDelegate?
	
	mutating func fetchData() {
		if page > 10 { return }
		let urlString = baseURL + String(page)
		getData(with: urlString)
	}
	
	func getData(with urlString: String) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					self.delegate?.didFailWithError(error: error!)
				}
				if let safeData = data {
					if let people = self.parseJSON(safeData){
						self.delegate?.didUpdateData(self, person: people)
					}
				}
			}
			task.resume()
		}
	}
	
	func parseJSON(_ safeData: Data) -> [PersonModel]? {
		let decoder = JSONDecoder()

		do {
			let decodedData = try decoder.decode([PersonData].self, from: safeData)
			var peopleArray = [PersonModel]()
			
			for person in decodedData {
				let personID = person.id
				let personName = person.name
				let personAvatar = person.avatar
				let personEmail = person.email
				let personModel = PersonModel(id: personID, name: personName, avatar: personAvatar, email: personEmail)
				peopleArray.append(personModel)
			}
			
			return peopleArray
			
		} catch {
			self.delegate?.didFailWithError(error: error)
			return nil
		}
	}
}

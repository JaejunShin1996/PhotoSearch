//
//  ViewModel.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 9/12/2022.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {
    @Published var images = [UIImage]()
    @Published var cancellable = Set<AnyCancellable>()

    let cacheManager = CacheManager.instance

    func fetch(text: String) {
        self.fetchResult(text: text) { results in
            DispatchQueue.main.async {
                self.images = []
                self.fetchImagesFromResults(results: results)
            }
        }
    }

    func fetchResult(text: String, completion: @escaping ([Result]) -> Void) {
        let url = URL(string: "https://api.unsplash.com/search/photos?page=1&per_page=30&query=\(text)&client_id=3a32gwglWqa6v67N9zigr0SGQeLaYwjvlmhu5yHrItg")!

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(jsonResult.results)
            } catch {
                completion([])
                print("fetch error, \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchImagesFromResults(results: [Result]) {
        for result in results {
            let urlString = result.urls.regular
            guard let url = URL(string: urlString) else { continue }

            // URLSession.shared.dataTask(with: url)
            /*
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard
//                    let data = data,
//                    let image = UIImage(data: data),
//                    let response = response as? HTTPURLResponse,
//                    response.statusCode >= 200 && response.statusCode < 300 else {
//                    completion(nil)
//                    return
//                }
//                completion(image)
//                cacheManager.add(image: image, name: urlString)
//            }.resume()
             */

            // Combine
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> UIImage in
                    guard
                        let image = UIImage(data: data),
                        let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    self.cacheManager.add(image: image, name: urlString)
                    return image
                }
                .sink { completion in

                } receiveValue: { [weak self] returnedImg in
                    self?.images.append(returnedImg)
                }
                .store(in: &cancellable)
        }
    }


}

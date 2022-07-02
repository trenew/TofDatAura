//
//  UnsplashService.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Foundation
import Combine
import SwiftUI

class UnsplashService {
    static func loadTodayPhotos(count: Int = Constants.UnsplashAPI.count,
                                take: Int = Constants.UnsplashAPI.itemsPerPage,
                                page: Int = 0,
                                orderBy: Order = Order.latest,
                                completion:@escaping ([Photo]) -> ()) {

        var urlComponents = URLComponents(string: "\(Constants.UnsplashAPI.scheme)://\(Constants.UnsplashAPI.host)\(Constants.UnsplashAPI.path)")

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.UnsplashAPI.apiKey),
            URLQueryItem(name: "count", value: String(count)),
            URLQueryItem(name: "per_page", value: String(take)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "order_by", value: String(orderBy.rawValue)),
        ]

        let url = urlComponents?.url?.absoluteURL
        guard url != nil else {
            print ("URL → Invalid...")
            return
        }

        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                if let error = error {
                    self.handleError(error: error)
                    completion([])
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion([])
                    return
                }
                guard data != nil else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion([])
                    return
                }
                let photos =  try JSONDecoder().decode([Photo].self, from: data!)
                DispatchQueue.main.async {
                    completion(photos)
                }
            } catch let error {
                self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                print (error)
            }
        }.resume()
    }

    static func searchPhotos(query: String,
                             take: Int = Constants.UnsplashAPI.itemsPerPage,
                             page: Int = 0,
                             orderBy: Order = Order.latest,
                             completion:@escaping (SearchResults) -> ()) {

        var urlComponents = URLComponents(string: "\(Constants.UnsplashAPI.scheme)://\(Constants.UnsplashAPI.host)\(Constants.UnsplashAPI.search)\(Constants.UnsplashAPI.path)")

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.UnsplashAPI.apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: String(take)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "order_by", value: String(orderBy.rawValue)),
        ]

        let url = urlComponents?.url?.absoluteURL
        guard url != nil else {
            print ("URL → Invalid...")
            return
        }

        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                if let error = error {
                    self.handleError(error: error)
                    completion(SearchResults())
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion(SearchResults())
                    return
                }

                guard data != nil else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion(SearchResults())
                    return
                }

                let photos =  try JSONDecoder().decode(SearchResults.self, from: data!)

                DispatchQueue.main.async {
                    completion(photos)
                }
            } catch let error {
                self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                print (error)
            }
        }.resume()
    }

    static func handleError(error: Error) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showAnAlert,
                                            object:
                                                AlertData(title: Text("⚠️ Error occured"),
                                                          message: Text("""
                                        \n📡 Network error!
                                        \n(♨️ possibly API limit reached)\n
                                        \n⏳ please try again in one hour
                                        """),
                                                          dismissButton: .default(Text("OK")) {
                print("Alert dismissed")
            }))
        }
    }

    static func loadRandomPhotos(count: Int = Constants.UnsplashAPI.count,
                                 take: Int = Constants.UnsplashAPI.itemsPerPage,
                                 page: Int = 0,
                                 orderBy: Order = Order.latest,
                                 completion:@escaping ([Photo]) -> ()) {

        var urlComponents = URLComponents(string: "\(Constants.UnsplashAPI.scheme)://\(Constants.UnsplashAPI.host)\(Constants.UnsplashAPI.path)\(Constants.UnsplashAPI.random)")

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.UnsplashAPI.apiKey),
            URLQueryItem(name: "count", value: String(count)),
            URLQueryItem(name: "per_page", value: String(take)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "order_by", value: String(orderBy.rawValue)),
        ]

        let url = urlComponents?.url?.absoluteURL
        guard url != nil else {
            print ("URL → Invalid...")
            return
        }

        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                if let error = error {
                    self.handleError(error: error)
                    completion([])
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion([])
                    return
                }
                guard data != nil else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion([])
                    return
                }
                let photos =  try JSONDecoder().decode([Photo].self, from: data!)
                DispatchQueue.main.async {
                    completion(photos)
                }
            }
            catch let error {
                self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                print (error)
            }
        }.resume()
    }

    static func getPhotoInfo(id: String, completion:@escaping (PhotoDetailed) -> ()) {
        var urlComponents = URLComponents(string: "\(Constants.UnsplashAPI.scheme)://\(Constants.UnsplashAPI.host)\(Constants.UnsplashAPI.path)/" + id)

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.UnsplashAPI.apiKey),
        ]

        let url = urlComponents?.url?.absoluteURL
        guard url != nil else {
            print ("URL → Invalid...")
            return
        }

        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                if let error = error {
                    self.handleError(error: error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    return
                }
                guard data != nil else {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    return
                }
                let photo =  try JSONDecoder().decode(PhotoDetailed.self, from: data!)
                DispatchQueue.main.async {
                    completion(photo)
                }
            } catch let error {
                self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                print (error)
            }
        }.resume()
    }
}

public extension Notification.Name {
    static let showAnAlert = Notification.Name("showAnAlert")
}

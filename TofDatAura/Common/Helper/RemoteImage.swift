//
//  RemoteImage.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Combine
import SwiftUI

struct RemoteImage: View {
    var url: URL
    @StateObject var viewModel = ImageProvider()
    var body: some View {
        Image(uiImage: viewModel.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear {
                viewModel.loadImage(url: url)
            }
    }
}

class ImageProvider: ObservableObject {
    @Published var image = UIImage(named: "placeholder")!
    private var cancellable: AnyCancellable?
    private let imageLoader = ImageLoader()

    func loadImage(url: URL) {
        self.cancellable = imageLoader.publisher(for: url)
            .sink(receiveCompletion: { failure in
                print(failure)
            }, receiveValue: { image in
                self.image = image
            })
    }
}

class ImageLoader {

    private let urlSession: URLSession
    private let cache: NSCache<NSURL, UIImage>

    init(urlSession: URLSession = .shared,
         cache: NSCache<NSURL, UIImage> = .init()) {
        self.urlSession = urlSession
        self.cache = cache
    }

    func publisher(for url: URL) -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: url as NSURL) {
            return Just(image)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return urlSession
                .dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.badServerResponse, userInfo: [
                            NSURLErrorFailingURLErrorKey: url
                        ])
                    }
                    return image
                }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { [cache] image in
                    cache.setObject(image, forKey: url as NSURL)
                })
                .eraseToAnyPublisher()
        }
    }
}

//
//  ContentView.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 7/12/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var collections: FetchedResults<PhotoCollection>
    
    @EnvironmentObject var dataController: DataController
    @StateObject var vm = ViewModel()
    let cacheManager = CacheManager.instance

    @State private var search = ""

    var vScrollPhotoView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(vm.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height * 0.7)
                        .contextMenu {
                            ForEach(collections, id: \.id) { collection in
                                Button {
                                    saveToCollection(image: image, collection: collection)
                                } label: {
                                    Label("Save to \(collection.unwrappedTitle)", systemImage: "photo")
                                }
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
    }

    var searchAndNextButton: some View {
        VStack {
            HStack {
                Spacer()

                NavigationLink {
                    CollectionView(dataController: dataController)
                } label: {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                }
            }
            .padding([.trailing, .top])

            Spacer()

            HStack {
                TextField("Search...", text: $search)
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .bold()
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Button {
                    vm.fetch(text: search)
                } label: {
                    Text("Search")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.trailing)
                }
            }
            .offset(y: -UIScreen.main.bounds.height * 0.05)
            .padding(.bottom)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                vScrollPhotoView

                searchAndNextButton
            }
        }
        .onAppear {
            vm.fetch(text: "study")
        }
        .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.immediately)
    }

    func saveToCollection(image: UIImage, collection: PhotoCollection) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let newPhoto = SavedPhoto(context: moc)
            newPhoto.creationDate = Date.now
            newPhoto.photoData = data
            newPhoto.collection = collection
        }

        dataController.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  CollectionView.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 12/12/2022.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)]) var collections: FetchedResults<PhotoCollection>

    var dataController: DataController

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var backAndAddButtons: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
            }

            Spacer()

            Button {
                addCollection()
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
            }
        }
        .padding()
    }

    var gridCollections: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(collections, id: \.id) { collection in
                ZStack {
                    if let firstPhoto = collection.savedPhotos.first?.photoData {
                        NavigationLink  {
                            EachCollectionView(collection: collection)
                        } label: {
                            Rectangle()
                                .fill(Color.white.opacity(1))
                                .overlay {
                                    Image(uiImage: UIImage(data: firstPhoto)!)
                                        .resizable()
                                        .scaledToFill()
                                }
                        }
                    }
                    Text(collection.unwrappedTitle)
                }
                .frame(width: UIScreen.main.bounds.width * 0.5 - 30,
                       height: UIScreen.main.bounds.height * 0.3)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
                .contextMenu {
                    Button(role: .destructive) {
                        deleteCollection(collection)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    var body: some View {
        VStack {
            backAndAddButtons

            ScrollView(showsIndicators: false) {
                gridCollections
            }
        }
        .navigationBarBackButtonHidden()
    }

    func addCollection() {
        let newCollection = PhotoCollection(context: moc)
        newCollection.id = UUID()
        newCollection.title = "New collection"
        newCollection.date = .now
        newCollection.photos = []

        DispatchQueue.main.async {
            dataController.save()
        }
    }

    func deleteCollection(_ object: PhotoCollection) {
        DispatchQueue.main.async {
            dataController.delete(object)
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(dataController: DataController())
    }
}

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

    @State var showingPopup = true

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                gridCollections
            }

            VStack {
                backAndAddButtons

                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }

    var backAndAddButtons: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
            }

            Spacer()

            Text("Collections")
                .font(.headline)
                .foregroundColor(Color.orange)

            Spacer()

            Button {
                addCollection()
            } label: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
            }
        }
        .padding([.horizontal , .top])
    }

    var gridCollections: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(collections, id: \.id) { collection in
                ZStack {
                    if let firstPhoto = collection.savedPhotos.first?.photoData {
                        NavigationLink  {
                            DetailCollectionView(collection: collection, tempString: collection.unwrappedTitle)
                        } label: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .overlay {
                                    Image(uiImage: UIImage(data: firstPhoto)!)
                                        .resizable()
                                        .scaledToFill()
                                }
                        }
                    }
                    Text(collection.unwrappedTitle)
                }
                .frame(width: UIScreen.main.bounds.width * 0.5 - 10,
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
        .offset(y: UIScreen.main.bounds.height * 0.1)
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
        CollectionView(dataController: DataController.preview)
    }
}

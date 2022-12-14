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

    @State var showingPopup = false
    @State var newTitle = ""
    @State var currentTitle = "New collection"

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
                    .fill(Color.orange)
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
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(collections, id: \.id) { collection in
                ZStack {
                    if let firstPhoto = collection.savedPhotos.first?.photoData {
                        NavigationLink  {
                            EachCollectionView(collection: collection)
                        } label: {
                            Rectangle()
                                .fill(Color.white.opacity(0))
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
                    Button {
                        currentTitle = collection.unwrappedTitle
                        withAnimation(.spring()) {
                            showingPopup.toggle()
                        }
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        deleteCollection(collection)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .padding(.horizontal)
        .offset(y: UIScreen.main.bounds.height * 0.1)
    }

    var editPopup: some View {
        VStack {
            VStack {
                HStack {
                    Text("Current title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    Spacer()
                }

                Text(currentTitle)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 50)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)

                HStack {
                    Text("New title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    Spacer()
                }

                TextField("New title...", text: $newTitle)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 50)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)

                HStack {
                    Button {
                        withAnimation(.spring()) {
                            showingPopup.toggle()
                        }
                    } label: {
                        Text("Dismiss")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                    .offset(x: -20)

                    Button {

                    } label: {
                        Text("Confirm")
                            .font(.headline)
                            .foregroundColor(Color.yellow)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                    .offset(x: 20)
                }
                .padding()
                .offset(y: 20)
            }
            .offset(y: -UIScreen.main.bounds.height * 0.17)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
        .background(Color.orange)
        .cornerRadius(50)
        .offset(y: showingPopup ?
                UIScreen.main.bounds.height * 0.4
                : UIScreen.main.bounds.height * 0.9)
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                gridCollections
            }

            VStack {
                backAndAddButtons

                Spacer()
            }

            Color.secondary.opacity(0.000001)
                .frame(maxWidth: .infinity)
                .offset(y: showingPopup ? -100 : UIScreen.main.bounds.height)

            editPopup
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

//
//  DetailCollectionView.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 12/12/2022.
//

import SwiftUI

struct DetailCollectionView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    var collection: PhotoCollection

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @State private var showingBackgroundCover = false
    @State private var showingPopup = false
    @State private var newTitle = ""
    @State private var tempTitle: String
    @State private var checkingChange = false

    init(collection: PhotoCollection, tempString: String) {
        self.collection = collection
        _tempTitle = State(wrappedValue: tempString)
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                forEachImageView
            }

            VStack {
                hStackTopView

                Spacer()
            }
            .padding()

            if showingBackgroundCover {
                Color.secondary.opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }

            VStack {
                VStack {
                    HStack {
                        Text("Current title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)

                        Spacer()
                    }

                    Text(collection.unwrappedTitle)
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .background(Color.secondary.opacity(0.5))
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
                        .foregroundColor(Color.black)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .background(Color.secondary.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    HStack {
                        Button {
                            showingBackgroundCover.toggle()
                            withAnimation(.spring()) {
                                showingPopup.toggle()
                            }
                        } label: {
                            Text("Dismiss")
                                .font(.title)
                                .foregroundColor(Color.gray)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(20)
                        }
                        .offset(x: -20)

                        Button {
                            showingBackgroundCover.toggle()
                            checkingChange.toggle()
                            withAnimation(.spring()) {
                                showingPopup.toggle()
                                tempTitle = newTitle
                            }
                        } label: {
                            Text("Confirm")
                                .font(.title)
                                .foregroundColor(Color.yellow)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(20)
                        }
                        .offset(x: 20)
                    }
                    .padding()
                }
                .offset(y: -UIScreen.main.bounds.height * 0.15)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
            .background(Color.orange)
            .cornerRadius(50)
            .offset(y: showingPopup ?
                    UIScreen.main.bounds.height * 0.4
                    : UIScreen.main.bounds.height * 0.9)
        }
        .navigationBarBackButtonHidden()
    }

    var hStackTopView: some View {
        HStack {
            Button {
                dismiss()
                if checkingChange {
                    collection.title = newTitle
                    dataController.save()
                }
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

            Text(tempTitle)
                .font(.headline)
                .foregroundColor(Color.orange)

            Spacer()

            Button {
                showingBackgroundCover.toggle()
                withAnimation(.spring()) {
                    showingPopup.toggle()
                }
            } label: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(Color.white)
                    }
            }
        }
    }

    var forEachImageView: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(collection.savedPhotos, id: \.id) { photo in
                Image(uiImage: UIImage(data: photo.unwrappedPhotoData)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.33)
                    .clipped()
            }
        }
        .offset(y: UIScreen.main.bounds.height * 0.1)
    }
}

struct DetailCollectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailCollectionView(collection: PhotoCollection.example, tempString: "Example")
    }
}

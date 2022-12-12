//
//  EachCollectionView.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 12/12/2022.
//

import SwiftUI

struct EachCollectionView: View {
    @Environment(\.dismiss) var dismiss
    
    var collection: PhotoCollection

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
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
            }
            .padding()

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(collection.savedPhotos, id: \.id) { photo in
                        Image(uiImage: UIImage(data: photo.unwrappedPhotoData)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.33)
                            .clipped()
                    }
                }
            }
        }

        .navigationBarBackButtonHidden()
    }
}

//struct EachCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        EachCollectionView(collection: <#PhotoCollection#>)
//    }
//}

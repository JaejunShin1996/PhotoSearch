//
//  ContentView.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 7/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    let cacheManager = CacheManager.instance

    @State private var search = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height * 0.7)
                    }
                }
            }

            VStack {
                Spacer()

                HStack {
                    TextField("Search...", text: $search)
                        .font(.title)
                        .bold()
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Button {
                        vm.fetch(text: search)
                    } label: {
                        Text("Search")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.trailing)
                    }
                }
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            vm.fetch(text: "messi")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

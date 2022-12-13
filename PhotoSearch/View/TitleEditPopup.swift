//
//  TitleEditPopup.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 13/12/2022.
//

import SwiftUI

//struct TitleEditPopup: View {
//    @State var showingPopup = true
//    @State var newTitle = ""
//    @State var currentTitle = "New collection"
//
//    var editPopup: some View {
//        VStack {
//            Button("CLiiiiick") {
//                withAnimation(.spring()) {
//                    showingPopup.toggle()
//                }
//            }
//            .font(.title)
//            .padding()
//            .background(Color.orange)
//
//            VStack {
//                VStack {
//                    HStack {
//                        Text("Current title")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .padding(.leading)
//
//                        Spacer()
//                    }
//
//                    Text(currentTitle)
//                        .font(.headline)
//                        .padding(.leading)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .frame(height: 50)
//                        .background(Color.secondary)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//
//                    HStack {
//                        Text("New title")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .padding(.leading)
//
//                        Spacer()
//                    }
//
//                    TextField("New title...", text: $newTitle)
//                        .font(.headline)
//                        .padding(.leading)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .frame(height: 50)
//                        .background(Color.secondary)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//
//                    HStack {
//                        Button {
//
//                        } label: {
//                            Text("Dismiss")
//                                .font(.title)
//                                .foregroundColor(Color.gray)
//                                .padding()
//                                .background(Color.black)
//                                .cornerRadius(20)
//                        }
//                        .offset(x: -20)
//
//                        Button {
//
//                        } label: {
//                            Text("Confirm")
//                                .font(.title)
//                                .foregroundColor(Color.yellow)
//                                .padding()
//                                .background(Color.black)
//                                .cornerRadius(20)
//                        }
//                        .offset(x: 20)
//                    }
//                    .padding()
//                }
//                .offset(y: -UIScreen.main.bounds.height * 0.02)
//            }
//            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
//            .background(Color.orange)
//            .cornerRadius(50)
//            .offset(y: showingPopup ?
//                    UIScreen.main.bounds.height * 0.3
//                    : UIScreen.main.bounds.height * 0.7)
//        }
//    }
//}
//
//struct TitleEditPopup_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleEditPopup()
//    }
//}

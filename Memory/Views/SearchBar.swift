//
//  SearchBar.swift
//  Memory
//
//  Created by Carl Hung on 28/08/2023.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding
    var text: String
    
    @Binding
    var path: NavigationPath
    
    @State
    var showAlert = false
    
    var model: HomeViewModel
    
    var cleanButtonAction: () -> Void = {}
    
    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .modifier(ClearButton(text: $text, action: cleanButtonAction))
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            DefaultButton(action: {
                let searchUsername = self.text
                guard !searchUsername.isEmpty else {
                    return
                }
                Task {
                    let nsid: String?
                    if searchUsername.contains("@") {
                        nsid = searchUsername.uppercased()
                    } else if let NSIDresult = try await model.searchUser(name: searchUsername) {
                        nsid = NSIDresult
                    } else {
                        nsid = nil
                    }
                    
                    guard let nsid else {
                        showAlert = true
                        return
                    }

                    path.append(nsid)
                    self.text = ""
                }
            }) {
                Text("User")
            }
            .alert("No such user", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel, action: {})
            })
            
            DefaultButton(action: {
                let searchTags = self.text
                guard !searchTags.isEmpty else {
                    return
                }
                Task {
                    try await model.searchTaggedPhotos(tags: searchTags)
                }
            }) {
                Text("Tags")
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

private struct DefaultButton<Content: View>: View {
    
    let action: () -> Void
    
    @ViewBuilder
    let content: Content
    
    var body: some View {
        Button(action: action) {
            content
        }
        .padding(.all, 5)
        .defaultRoundedRectangle(.black, lineWidth: 2, cornerRadius:  5)
    }
}

private struct ClearButton: ViewModifier {
    @Binding var text: String
    
    let action: () -> Void

    init(text: Binding<String>, action: @escaping () -> Void) {
        self._text = text
        self.action = action
    }

    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.secondary)
                .opacity(text == "" ? 0 : 1)
                .onTapGesture {
                    self.text = ""
                    action()
                }
        }
    }
}

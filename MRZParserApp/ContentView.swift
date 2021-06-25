//
//  ContentView.swift
//  MRZParserApp
//
//  Created by Brenton Niebauer on 6/21/21.
//

import SwiftUI

struct ContentView: View {
    @State var mrzEntry: String = ""
    @State var parsed: Bool = false
    @State var showingAlert: Bool = false
    @State var name: String = ""
    @State var country: String = ""
    @State var userList: [UserData] = []
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            TextField("MRZ Entry", text: $mrzEntry)
                .font(.title3)
                .border(Color.black)
            Button(action: {
                updateUI()
            }, label: {
                Text("Parse Name")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(CGFloat(10), antialiased: true)
                    .padding(10)
                    
            })
            .animation(.interactiveSpring())
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("An error occured"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
            if parsed {
                VStack(alignment: .leading) {
                    Text("Name: \(name)")
                    Text("Country: \(country)")
                }
            }
            if userList.count > 0 {
                withAnimation(.easeIn){
                    List {
                        ForEach(userList, id: \.id) { user in
                            HStack {
                                Text("UserName: \(user.login)")
                                Link(destination: URL(string: user.html_url)!) {
                                    Text("Click for GitHub Page")
                                        .font(.headline)
                                        .underline()
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        
    }
    
    func updateUI() {
        do {
            let mrzData = try MRZParser.shared.parseMRZ(from: mrzEntry)
            parsed = true
            name = "\(mrzData!.givenName) \(mrzData!.surName)"
            country = mrzData!.countryCode
            let query = [
                "q": name
            ]
            GitHubRequestController.shared.fetchUsers(matching: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userData):
                        print(userData)
                        userList = userData
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        } catch {
            // Display Error
            errorMessage = error.localizedDescription
            showingAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

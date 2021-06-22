//
//  ContentView.swift
//  MRZParserApp
//
//  Created by Brenton Niebauer on 6/21/21.
//

import SwiftUI

struct ContentView: View {
    @State var mrzEntry: String = ""
    @State var name: String = ""
    @State var userList: [UserData] = []
    
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
            Text(name)
            if userList.count > 0 {
                List {
                    ForEach(userList, id: \.id) { user in
                        Text("UserName: \(user.login)")
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        
    }
    
    func updateUI() {
        name = MRZParser.shared.parseMRZ(from: mrzEntry)
        
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  SwiftUIBasicExample
//
//  Created by Christian Quicano on 14/09/21.
//

import SwiftUI

struct MainNavigationView: View {
    
    let items = (0...3).map { Item(id: $0, value: $0) }
    let person = Person()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ListView(),
                    label: {
                        Text("List")
                            .font(.title)
                    })
                
                NavigationLink(
                    destination: ListFilter(),
                    label: {
                        Text("List filter")
                            .font(.title)
                    })
                
                
                Text("Color Game View")
            }
            .navigationBarTitle("Example")
        }
        .environmentObject(person)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainNavigationView()
    }
}

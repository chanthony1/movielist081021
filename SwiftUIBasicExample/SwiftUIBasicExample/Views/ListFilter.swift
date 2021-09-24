//
//  ListFilter.swift
//  SwiftUIBasicExample
//
//  Created by Christian Quicano on 17/09/21.
//

import SwiftUI

struct ListFilter: View {
    
    var array = Dish.all()
    
    @State private var isSpicy = true
    
    var body: some View {
        
        List {
            Toggle(isOn: $isSpicy, label: {
                Text("Spicy")
                    .font(.title)
            })
            
            ForEach(array.filter { $0.isSpicy == self.isSpicy }) { element in
                HStack {
                    Image(element.imageURL)
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text(element.name)
                        .font(.title)
                        .lineLimit(nil)
                    
                    Spacer()
                    
                    if element.isSpicy {
                        Image("spicy-icon")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
        .navigationBarTitle("Filter List", displayMode: .inline)
        
    }
}

struct ListFilter_Previews: PreviewProvider {
    static var previews: some View {
        ListFilter()
    }
}

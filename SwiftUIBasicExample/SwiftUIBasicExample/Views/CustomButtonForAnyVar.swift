//
//  CustomButtonForAnyVar.swift
//  SwiftUIBasicExample
//
//  Created by Christian Quicano on 17/09/21.
//

import SwiftUI

struct CustomButtonForAnyVar: View {
    
    @Binding private (set) var anyVar: Bool
    @EnvironmentObject var person: Person
    
    private func changeAnyVar() {
        anyVar = !anyVar
        print("CustomButtonForAnyVar: Name of the person \(person.name)")
        person.name = "new name"
    }
    
    var body: some View {
        Button(action: changeAnyVar, label: {
            Text("Change any var")
                .font(.title)
        })
    }
    
}

struct CustomButtonForAnyVar_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonForAnyVar(anyVar: .constant(true))
    }
}

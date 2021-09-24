//
//  ListView.swift
//  SwiftUIBasicExample
//
//  Created by Christian Quicano on 17/09/21.
//

import SwiftUI

class Person: ObservableObject {
    var name: String = "Christian"
}

struct ListView: View {
    
    @State private var tasks = [Task]()
    @State private var anyVar = true
    
    @EnvironmentObject var person: Person
    
    private func addRow() {
        tasks.append(Task())
        print("ListView: Name of the person \(person.name)")
        print(tasks.count)
    }
    
    
    var body: some View {
        print("new change")
        
        return VStack {
            Text("we have \(tasks.count) tasks")
            
            
            CustomButtonForAnyVar(anyVar: $anyVar)
            
            if anyVar {
                Text("it is true")
            } else {
                Text("it is false")
            }
            
            
            Button(action: addRow, label: {
                Text("Add Task")
                    .font(.title)
            })
            List {
                ForEach(tasks) { task in
                    Text("\(task.name) : \(tasks.count)")
                }
            }
        }
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

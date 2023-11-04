//
//  ContentView.swift
//  skoluppgift4
//
//  Created by Joakim Sjöstedt on 2023-10-27.
//

import SwiftUI

struct MachineGuessSection: View {
    @Binding var type: String
    var name: String
    
    var body: some View {
        VStack {
            Image(name)

            Text("This is a...\(type)")
                .padding()
            
            Button(action: {
                type = MachineLearningModel.identifyImage(named: name)
            }, label: {
                Text("MyButton")
            })
        }
    }
}

struct ContentView: View {
    @State var typeOne = ""
    @State var typeTwo = ""
    
    var body: some View {
        HStack {
            MachineGuessSection(type: $typeOne, name: "elephant")
            MachineGuessSection(type: $typeTwo, name: "cat")
        }
    }
}

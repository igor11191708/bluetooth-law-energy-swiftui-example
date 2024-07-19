//
//  bluetooth_law_energy_exampleApp.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 12.07.24.
//

import SwiftUI



@main
struct PicookApp: App {
    
    @State var isOne: Bool = true
    
    var body: some Scene {
        WindowGroup {
            VStack(alignment: .leading, spacing : 15){
                Group{
                    HStack{
                        Toggle("Destroy manager", isOn: $isOne)
                            .font(.title3)
                        Spacer()
                    }
     
                    if isOne {
                      ContentView()
                    }
                    if !isOne{ Spacer() }
                
                }.padding(.horizontal)
            }.padding(.top)
             .preferredColorScheme(.dark)
        }
    }
}

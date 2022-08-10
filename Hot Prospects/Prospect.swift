//
//  Prospect.swift
//  Hot Prospects
//
//  Created by Ritwik Pahwa on 15/07/22.
//

import Foundation



class Prospect: Identifiable, Codable{
    
    var id = UUID()
    var name: String = ""
    var email: String = ""
    fileprivate(set) var isContacted = false

}


@MainActor class Prospects: ObservableObject{
    @Published private(set) var people: [Prospect]
    
    let keyName = "SavedData"
    
    init(){
        
        if let data  = UserDefaults.standard.data(forKey: keyName){
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data){
                people = decoded
                return
            }
        }
        
        people = []
    }
    
    
    private func save(){
        if let encoded = try? JSONEncoder().encode(people){
            UserDefaults.standard.set(encoded, forKey: keyName)
        }
    }
    
    func add(_ prospect: Prospect){
        people.append(prospect)
        save()
    }
    
    public func toggle(_ prospect: Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}

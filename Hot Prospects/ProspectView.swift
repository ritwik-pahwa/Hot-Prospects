//
//  ProspectView.swift
//  Hot Prospects
//
//  Created by Ritwik Pahwa on 15/07/22.
//
import CodeScanner
import SwiftUI

struct ProspectView: View {
    
    enum Filtertype {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    
    let filter: Filtertype
    
    var body: some View {
        NavigationView{
            List{
                ForEach(filteredProspects){ prospect in
                    VStack(alignment: .leading){
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.email)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if prospect.isContacted{
                            Button{
                                prospects.toggle(prospect)
                            }label : {
                                Label("Mark UnContacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        }
                        else{
                            Button {
                                prospects.toggle(prospect)
                            }label: {
                                Label("Mark contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button{
                    isShowingScanner = true
                    
                    
                }label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Ritwik Pahwa\nritwikpahwa@gmail.com", completion: handleScanner)
            }
               
        }
       
    }
    
    
    func handleScanner (result: Result<ScanResult, ScanError>){
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.email = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed \(error.localizedDescription)")
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Uncontacted"
        }
    }
    
    
    var filteredProspects: [Prospect]{
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted}
        case .uncontacted:
            return prospects.people.filter{!$0.isContacted}
        }
    }
    
    
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
            .environmentObject(Prospects())
    }
}

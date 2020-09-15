//
//  ContentView.swift
//  NotificationPOC16
//
//  Created by G Kiran Kumar on 15/09/20.
//  Copyright © 2020 G Kiran Kumar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let todoPublisher = NotificationCenter.default.publisher(for: NSNotification.Name("Detail"))

    @State var show: Bool = false
    @State var navigationTitle: String = "First"

    var body: some View {
        NavigationView {
            VStack {
                    NavigationLink(destination: Detail(), isActive: self.$show) { Text("")}.hidden()
                    TabView() {
                        FirtstView(navigationTitle: self.$navigationTitle)
                        .tabItem {
                            Image(systemName: "1.circle")
                            Text("First")
                        }.tag(0)
                            
                        ListView(navigationTitle: self.$navigationTitle)
                       // ListView()
                        .tabItem {
                            Image(systemName: "2.circle")
                            Text("Second")
                        }.tag(1)
                            
                }

            }
        .navigationBarTitle(navigationTitle)
        }
        .onReceive(todoPublisher) {notification in
            self.show = true
        }
      
    }
    
          func push() {
              let currentview = UIApplication.shared.connectedScenes
              print(currentview)
          }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


struct FirtstView: View {
    @Binding var navigationTitle: String
    
    var body: some View {
                      VStack {
                           VStack {
                                Button(action: {
                                        print("Requesting Permission")
                                        self.requestAutherization()
                                }){
                                Text("Request Permission")
                                }
                                Button(action: {
                                    print("Scheduling notificaion")
                                    self.requestNotification()
                                }){
                                    Text("schedule notificaion")
                                }
                            }
                          
                          }
        .navigationBarTitle("First")
        .onAppear() {
          self.navigationTitle = "First"
          }
    }
    
    //Request Authization
    func requestAutherization() {
                 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                 if success{
                     print("Ready to take Notifications")
                 } else if let error = error {
                     print(error.localizedDescription)
                 }
             })
       }
    
    //Sechdule notification
    func requestNotification() {
        let id = UUID().uuidString

        
        let content1 = UNMutableNotificationContent()
           content1.title = "This is local Notification"
           content1.body = ("resquestNotification")
           content1.sound = UNNotificationSound.default
        
           //show this notification five seconds from now
              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
           
           //choose a indentifier
             let request = UNNotificationRequest(identifier: id, content: content1, trigger: trigger)
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       }
  
}



    //MARK: LIST View

struct ListView: View {
    @Binding var navigationTitle: String
    var body: some View {
                List {
                    ForEach(0..<5) {data in
                        NavigationLink(destination: DetailView()) {
                                    Text("Text for row \(data)")
                            }
                        }
                }
        .onAppear() {
        self.navigationTitle = "Second"
        }
    }
}


struct DetailView: View {
    var body: some View {
        Text("Here is Detail View. Tap to go back.")
        .onAppear() {
        }
    }
    
}

struct Detail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
             Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Dismiss")
            }
            Text("Here is Detail. Tap to go back.")
        }
       
    }
}

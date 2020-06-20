//
//  ContentView.swift
//  SwiftUI MVVM
//
//  Created by Jesus Luongo Lizana on 6/19/20.
//  Copyright © 2020 Jesus Luongo Lizana. All rights reserved.
//

import SwiftUI

let apiUrl = "https://api.letsbuildthatapp.com/static/courses.json"

struct Course: Identifiable, Decodable {
  let id = UUID()
  let name: String
}

class CoursesViewModel: ObservableObject {
  @Published var messages = "Messages inside observable object"
  @Published var courses: [Course] = [
    .init(name: "Course1"),
    .init(name: "Course2"),
    .init(name: "Course3")
  ]
  
  func changeMessage() {
    self.messages = "Blah blah blah"
  }
  
  func fetchCourses(){
    // fetch json and decode
    guard let url = URL(string: apiUrl) else { return }
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
      DispatchQueue.main.async {
        self.courses = try! JSONDecoder().decode([Course].self, from: data!)
      }
    }.resume()
  }
}

struct ContentView: View {
  
  @ObservedObject var coursesVM = CoursesViewModel()
  
  var body: some View {
    NavigationView {
      
      ScrollView {
        Text(coursesVM.messages)
        ForEach(coursesVM.courses) { course in
          Text(course.name)
        }
      }.navigationBarTitle("Courses")
        .navigationBarItems(trailing: Button(action: {
          print("Fetching json data")
          self.coursesVM.fetchCourses()
        }, label: {Text("Fetch courses")}
        ))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

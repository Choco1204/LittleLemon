//
//  Menu.swift
//  Little Lemon
//
//  Created by Mimi_Son on 01/12/24.
//

import SwiftUI
import CoreData // Ensure CoreData is imported

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest to retrieve Dish objects
//    @FetchRequest(entity: Dish.entity(), sortDescriptors: [])
//    private var dishes: FetchedResults<Dish>
    
    @State private var dishes: [Dish] = []
    @State private var searchText: String = ""


    var body: some View {
        NavigationView{
            VStack {
                Text("Little Lemon")
                Text("Chicago")
                Text("Lorem ipsum is a placeholder text used in web development to demonstrate the functionality of a web page without actually writing any content.")
                TextField("Search menu", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { _ in
                        fetchDishes()
                    }

                List {
                    ForEach(dishes) { dish in
                        NavigationLink(destination: DishDetailView(dish: dish)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(dish.title ?? "")")
                                        .font(.headline)
                                    Text("\(dish.desc ?? "")")
                                    Text("$\(dish.price ?? "")")
                                        .font(.subheadline)
                                }
                                Spacer()
                                // Display image if available
                                if let imageUrlString = dish.image, let imageUrl = URL(string: imageUrlString) {
                                    AsyncImage(url: imageUrl) { image in
                                        image.resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Menu")
        .onAppear {
            getMenuData()
        }
    }

    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }

    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true) // No filtering
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    func fetchDishes() {
        let request: NSFetchRequest<Dish> = Dish.fetchRequest()
        request.sortDescriptors = buildSortDescriptors()
        request.predicate = buildPredicate()
        
        do {
            dishes = try viewContext.fetch(request)
        } catch {
            print("Error fetching dishes: \(error.localizedDescription)")
        }
    }
    
    func getMenuData() {
        // Clear the database before fetching new data
        PersistenceController.shared.clear()

        let serverURL = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: serverURL) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            // Ensure data is not nil
            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the JSON data
            do {
                let decoder = JSONDecoder()
                let menuList = try decoder.decode(MenuList.self, from: data)

                // Save dishes to Core Data on the main context
                DispatchQueue.main.async {
                    for menuItem in menuList.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = menuItem.title
                        dish.image = menuItem.image
                        dish.desc = menuItem.description
                        dish.price = menuItem.price
                    }

                    // Save the context to persist data
                    do {
                        try viewContext.save()
                        fetchDishes()
                    } catch {
                        print("Error saving context: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}


//#Preview{
// Menu()
//        
//}

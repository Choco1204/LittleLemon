//
//  HomeView.swift
//  Little Lemon
//
//  Created by Mimi_Son on 01/12/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // FetchRequest to retrieve Dish objects
    @FetchRequest(
        entity: Dish.entity(),
        sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)]
    )
    private var dishes: FetchedResults<Dish>

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Logo Section
                    logoSection

                    // Header Section
                    headerSection

                    // Order Section
                    orderSection

                    // Dishes List Section
                    dishesListSection
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
            .onAppear {
                if dishes.isEmpty {
                    loadSampleData()
                }
            }
        }
    }

    // MARK: - Logo Section
    private var logoSection: some View {
        HStack {
            Image("little-lemon-logo")
                .resizable()
                .frame(width: 150, height: 50) // Adjust size as per the logo's dimensions

            Spacer()

            Image("profile-image-placeholder")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Little Lemon")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)
                
                Text("Chicago")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .font(.body)
                    .foregroundColor(.white)
                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white) // Circle background for the magnifying glass
                                        .clipShape(Circle()) // Make it a perfect circle
                                }
                                .frame(maxWidth: .infinity, alignment: .leading) // Center horizontally
                                .padding(.top, 10)
            }

            Spacer()

            Image("Greek-salad") // Replace with your food image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color(red: 73 / 255, green: 94 / 255, blue: 87 / 255)) // Background color #495E57
        .cornerRadius(10)
    }

    // MARK: - Order Section
    private var orderSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ORDER FOR DELIVERY!")
                .font(.headline)
                .bold()
            
            HStack {
                ForEach(["Starters", "Mains", "Desserts", "Drinks"], id: \.self) { category in
                    Text(category)
                        .font(.subheadline)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - Dishes List Section
    private var dishesListSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            if dishes.isEmpty {
                Text("No dishes available.")
                    .font(.body)
                    .foregroundColor(.gray)
            } else {
                ForEach(dishes) { dish in
                    dishRow(for: dish)
                }
            }
        }
    }

    private func dishRow(for dish: Dish) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text(dish.title ?? "")
                    .font(.headline)
                
                Text(dish.desc ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text("$\(dish.price ?? "")")
                    .font(.subheadline)
                    .bold()
            }

            Spacer()

            if let imageUrlString = dish.image, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    // MARK: - Load Sample Data
    private func loadSampleData() {
        let sampleDishes = [
            ("Greek Salad", "A fresh and healthy salad with olives, feta cheese, and crispy lettuce.", "$12.99", "https://via.placeholder.com/150"),
            ("Bruschetta", "Grilled bread smeared with garlic and topped with fresh tomatoes and basil.", "$8.99", "https://via.placeholder.com/150"),
            ("Grilled Fish", "Barbecued fish with a hint of lemon and fresh herbs.", "$18.99", "https://via.placeholder.com/150"),
            ("Pasta", "Creamy Alfredo pasta with grilled chicken and Parmesan cheese.", "$15.99", "https://via.placeholder.com/150")
        ]

        for (title, desc, price, image) in sampleDishes {
            let dish = Dish(context: viewContext)
            dish.title = title
            dish.desc = desc
            dish.price = price
            dish.image = image
        }

        do {
            try viewContext.save()
        } catch {
            print("Failed to save sample data: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    HomeView()
//}

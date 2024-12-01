import SwiftUI

struct DishDetailView: View {
    let dish: Dish

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display the dish image
                if let imageUrlString = dish.image, let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                }

                // Display the dish title
                Text(dish.title ?? "")
                    .font(.largeTitle)
                    .bold()
                
                // Display the dish price
                Text("Price: $\(dish.price ?? "")")
                    .font(.title2)
                    .foregroundColor(.secondary)

                // Display the dish description if available
                Text(dish.desc ?? "")
                    .font(.subheadline)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(dish.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

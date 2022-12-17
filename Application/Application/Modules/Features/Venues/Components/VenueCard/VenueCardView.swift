import SwiftUI

struct VenueCard: View {
    typealias Model = VenueCardModel
    let model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                imageView
                descriptionContainerView
                Spacer()
                scoreTagView
            }
            userCommentView
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        AsyncImage(url: .init(string: model.imageURL)) { phase in
            switch phase {
            case .empty:
                Image(systemName: "gear.fill") // TODO: Find a proper empty placeholder
                
            case let .success(image):
                image.resizable()

            case .failure:
                Image(systemName: "gear.fill") // TODO: Find a proper error placeholder
                
            @unknown default:
                fatalError()
            }
        }
        .frame(width: 50, height: 50)
        .aspectRatio(contentMode: .fit)
        .cornerRadius(.pi)
    }
    
    @ViewBuilder
    private var descriptionContainerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Text 1")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                Text("Text 2")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Text 3")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var scoreTagView: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 32, height: 32)
                .foregroundColor(.green)
                .overlay {
                    Text(String(format: "%.1f", model.score))
                        .font(.callout)
                        .bold()
                        .foregroundColor(.white)
                }
        }
    }
    
    @ViewBuilder
    private var userCommentView: some View {
        Text(model.comment)
            .font(.subheadline)
            .foregroundColor(.primary)
    }
}

#if DEBUG
struct VenueCard_Previews: PreviewProvider {
    static var previews: some View {
        List {
            VenueCard(model: .mock)
            VenueCard(model: .mock)
            VenueCard(model: .mock)
            VenueCard(model: .mock)
        }
    }
}
#endif

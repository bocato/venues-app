import SwiftUI

struct VenueCard: View {
    typealias Model = VenueCardModel
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                imageView
                descriptionContainerView
                Spacer()
                scoreTagView
            }
            descriptionView
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        RemoteImage(url: .init(string: model.imageURL))
//        AsyncImage(url: .init(string: model.imageURL)) { phase in
//            switch phase {
//            case .empty, .failure:
//                Image(systemName: "photo")
//
//            case let .success(image):
//                image.resizable()
//
//            @unknown default:
//                fatalError()
//            }
//        }
        .frame(width: 50, height: 50)
        .aspectRatio(contentMode: .fit)
        .cornerRadius(.pi)
    }
    
    @ViewBuilder
    private var descriptionContainerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.headline)
                    .foregroundColor(.accentColor)
                if let kind = model.kind {
                    Text(kind)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(model.locationInfo)
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
                .overlay(ratingView)
        }
    }
    
    @ViewBuilder
    private var ratingView: some View {
        if let rating = model.rating {
            Text(String(format: "%.1f", rating))
                .font(.callout)
                .bold()
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        if let description = model.description {
            Text(description)
                .font(.footnote)
                .foregroundColor(.primary)
        }
    }
}

#if DEBUG
struct VenueCard_Previews: PreviewProvider {
    static var previews: some View {
        List {
            VenueCard(model: .fixture())
            VenueCard(model: .mockWithDescription)
        }
    }
}
#endif

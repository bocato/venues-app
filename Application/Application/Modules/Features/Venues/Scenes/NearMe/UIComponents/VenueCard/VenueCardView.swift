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
        RemoteImage(
            url: .init(string: model.imageURL)
        )
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
        if let rating = model.rating {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.green)
                    .overlay(
                        Text(String(format: "%.1f", rating))
                            .font(.callout)
                            .bold()
                            .foregroundColor(.white)
                    )
            }
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
            VenueCard(model: .mockWithAllFields)
            VenueCard(model: .mockWithRating)
            VenueCard(model: .mockWithDescription)
            VenueCard(model: .mockWithKind)
            VenueCard(model: .mockWithNoOptionalFields)
        }
    }
}
#endif

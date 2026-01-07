import SwiftUI

struct ProfileAvatar: View {
    let image: UIImage?
    var size: CGFloat = 32
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: size, height: size)
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.45, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    HStack {
        ProfileAvatar(image: nil)
        ProfileAvatar(image: nil, size: 72)
    }
    .padding()
}


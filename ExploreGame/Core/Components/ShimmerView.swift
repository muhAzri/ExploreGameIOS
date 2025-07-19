import SwiftUI

struct ShimmerView: View {
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.6),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: shimmerOffset)
                .onAppear {
                    withAnimation(
                        Animation.linear(duration: 1.5)
                            .repeatForever(autoreverses: false)
                    ) {
                        shimmerOffset = 200
                    }
                }
        }
        .clipped()
    }
}

struct GameDetailShimmerSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image placeholder
            ShimmerView()
                .frame(height: 200)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 12) {
                // Title placeholder
                ShimmerView()
                    .frame(height: 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Metadata row
                HStack {
                    ShimmerView()
                        .frame(width: 80, height: 16)
                    
                    Spacer()
                    
                    ShimmerView()
                        .frame(width: 60, height: 16)
                    
                    ShimmerView()
                        .frame(width: 40, height: 16)
                }
                
                // Platforms section
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerView()
                        .frame(width: 80, height: 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 100))
                    ], spacing: 8) {
                        ForEach(0..<6, id: \.self) { _ in
                            ShimmerView()
                                .frame(height: 28)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Genres section
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerView()
                        .frame(width: 60, height: 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80))
                    ], spacing: 8) {
                        ForEach(0..<8, id: \.self) { _ in
                            ShimmerView()
                                .frame(height: 28)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // ESRB Rating
                HStack {
                    ShimmerView()
                        .frame(width: 100, height: 20)
                    Spacer()
                    ShimmerView()
                        .frame(width: 60, height: 28)
                        .cornerRadius(8)
                }
                
                // Description section
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerView()
                        .frame(width: 100, height: 20)
                    
                    VStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { index in
                            ShimmerView()
                                .frame(height: 16)
                                .frame(maxWidth: index == 4 ? .infinity * 0.7 : .infinity, alignment: .leading)
                        }
                    }
                }
                
                // Links placeholders
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerView()
                        .frame(width: 120, height: 20)
                    
                    ShimmerView()
                        .frame(width: 140, height: 20)
                }
            }
            .padding()
        }
    }
}

struct GameRowShimmerSkeleton: View {
    var body: some View {
        HStack {
            // Image placeholder
            ShimmerView()
                .frame(width: 80, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                // Title placeholder
                ShimmerView()
                    .frame(height: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    // Date placeholder
                    ShimmerView()
                        .frame(width: 80, height: 12)
                    
                    Spacer()
                    
                    // Rating placeholder
                    HStack {
                        ShimmerView()
                            .frame(width: 40, height: 12)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct GameListShimmerSkeleton: View {
    var body: some View {
        LazyVStack {
            ForEach(0..<10, id: \.self) { _ in
                GameRowShimmerSkeleton()
                    .padding(.horizontal)
            }
        }
    }
}

#Preview("Game Detail Shimmer") {
    ScrollView {
        GameDetailShimmerSkeleton()
    }
}

#Preview("Game Row Shimmer") {
    GameRowShimmerSkeleton()
        .padding()
}

#Preview("Game List Shimmer") {
    ScrollView {
        GameListShimmerSkeleton()
    }
}
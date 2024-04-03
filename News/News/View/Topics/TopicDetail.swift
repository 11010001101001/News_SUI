//
//  Topic.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct TopicDetail: View {

    @ObservedObject var viewModel: ViewModel

    @Environment(\.openURL) private var openURL

    let article: Articles
    let action: Action

    @State var rotating = false
    @State var scale = 0.85

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: article.urlToImage ?? .empty)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: CGFloat.screenWidth - 32,
                               height: 300,
                               alignment: .center)
                        .clipped()
                        .clipShape(.buttonBorder)
                        .shadow(color: Color(image.averageColor), radius: 60)
                        .applyNice3DRotation(rotating: rotating)
                        .commonScaleAffect(state: rotating)
                        .onAppear { rotating.toggle() }
                } else if phase.error != nil {
                    ErrorView(
                        viewModel: viewModel,
                        title: "Error loading image...",
                        action: nil)
                    .applyNice3DRotation(rotating: rotating)
                    .commonScaleAffect(state: rotating)
                    .onAppear { rotating.toggle() }
                } else {
                    Loader()
                }
            }
            .frame(height: 300)
            .padding(.vertical)
            .padding(.horizontal)

            VStack {
                Text(article.description ?? .empty)
                    .padding(.bottom)
                    .padding(.horizontal)
                HStack {
                    ShareLink(item: URL(string: article.url ?? .empty)?.absoluteString ?? .empty,
                              subject: Text("Check it out"),
                              message: Text("Link to News app in appStore 🦾: stay informed!👨🏻‍🔧")) {
                        Button {
                            // TODO: Think about how animate shareLink view like button when pressed
                            viewModel.impactOccured(.light)
                        } label: {
                            Label(
                                title: { EmptyView() },
                                icon: { Image(systemName: "square.and.arrow.up") }
                            )
                        }
                        .allowsHitTesting(false)
                        .buttonStyle(.bordered)
                        .clipShape(.capsule(style: .continuous))
                        .controlSize(.regular)
                    }
                              .padding(.leading)
                    CustomButton(viewModel: viewModel,
                                 action: {
                        action?()
                        if let url = URL(string: article.url ?? .empty) {
                            openURL(url)
                        }
                    },
                                 title: "Open",
                                 iconName: nil)
                    Spacer()
                }
                Spacer()
                    .padding(.bottom)
            }
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.bouncy(duration: 0.6, extraBounce: 0.3)) {
                    scale = 1.0
                }
            }
        }
        .navigationTitle("Details")
    }
}

#Preview {
    TopicDetail(viewModel: ViewModel(),
                article: Articles(source: Source(id: UUID().uuidString,
                                                 name: "Source"),
                                  title: "Title",
                                  description: "Very long description of the topic if you really want this for testing for example i dont know what to type more here but i guess it's enough",
                                  publishedAt: "Time"),
                action: {
        print("tapped")
    })
}

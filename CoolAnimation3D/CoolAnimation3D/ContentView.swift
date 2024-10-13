//
//  ContentView.swift
//  CoolAnimation3D
//
//  Created by Rahul Nimje on 04/10/24.
//

import SwiftUI
import SplineRuntime

struct ContentView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Updated list of URLs for each header
    let headerURLs = [
        URL(string: "https://build.spline.design/NNRhNzpWsVGY83NC8Aqa/scene.splineswift"),
        URL(string: "https://build.spline.design/1H2Q781s5-VX2mC6y513/scene.splineswift"),
        URL(string: "https://build.spline.design/RLO9uXJHlv99kd1zDKx6/scene.splineswift"),
        URL(string: "https://build.spline.design/2-m3Ez05n3jH4W8DQGRX/scene.splineswift"),
        URL(string: "https://build.spline.design/fQOfDK4soZw8Hivjg8Mm/scene.splineswift"),
        URL(string: "https://build.spline.design/ygkCKOrSXX1HPWvVQqGR/scene.splineswift")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(headerURLs.indices, id: \.self) { index in
                        if let validURL = headerURLs[index] {
                            NavigationLink(destination: HeaderDetailView(url: validURL, index: index)) {
                                HeaderItem(url: validURL, index: index)
                                    .frame(height: 300)
                            }
                        } else {
                            Text("Invalid URL")
                                .frame(height: 300)
                                .background(Color.red.opacity(0.2))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Header Collection")
        }
        .ignoresSafeArea(.all)
    }
}

struct HeaderItem: View {
    let url: URL
    let index: Int

    var body: some View {
        VStack {
            HeaderPreview(url: url)
                .frame(height: 200)
                .cornerRadius(12)
            
            Text("Item \(index + 1)")
                .bold()
                .padding()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct HeaderPreview: View {
    let url: URL
    @State private var isLoading = true
    @State private var isLoaded = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(min(geometry.size.width, geometry.size.height) / 150)
                        .padding()
                } else if isLoaded {
                    SplineView(sceneFileURL: url)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .onAppear {
                loadContent()
            }
            .onDisappear {
                cleanupMemory()
            }
        }
    }
    
    private func loadContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.isLoaded = true
        }
    }

    private func cleanupMemory() {
        self.isLoaded = false
    }
}

struct HeaderDetailView: View {
    let url: URL
    let index: Int
    @State private var isLoaded = false
    
    var body: some View {
        VStack {
            if isLoaded {
                SplineView(sceneFileURL: url)
                    .frame(height: 500)
                    .cornerRadius(12)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        loadContent()
                    }
            }
            
            Text("Full Preview of Item \(index + 1)")
                .bold()
                .padding()
        }
        .navigationTitle("Detail View")
        .padding()
        .onDisappear {
            cleanupMemory()
        }
    }
    
    private func loadContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoaded = true
        }
    }

    private func cleanupMemory() {
        self.isLoaded = false
    }
}

#Preview {
    ContentView()
}

//
//  HomeView.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 24/02/26.
//
// Se cambió el principal de ContentView a HomeView
import SwiftUI

struct HomeView: View {
    @State private var rotation: Double = -45
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.opacity(0.05).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 30) {
                        Text("Pokédex")
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundStyle(.red)
                        
                        NavigationLink(destination: FilterView()) {
                            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .rotationEffect(.degrees(rotation))
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Text("Toca para entrar")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Divider()
                            .padding(.horizontal, 50)
                            .padding(.bottom, 10)
                        
                        Text("Datos extraídos de la PokéApi")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        if let url = URL(string: "https://pokeapi.co") {
                            Link("Fuente: pokeapi.co", destination: url)
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true)
                    ) {
                        rotation = 45
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}


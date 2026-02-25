//
//  PokeDetailView.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 24/02/26.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonEntry
    @State var pokemonVM = PokemonViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // --- IMAGEN OFICIAL ---
                let pokemonID = pokemon.url.split(separator: "/").last ?? "1"
                let artURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonID).png"
                
                AsyncImage(url: URL(string: artURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 250, height: 250)
                .padding()
                .background(Circle().fill(Color.gray.opacity(0.1)))

                // --- NOMBRE Y TIPOS ---
                VStack(spacing: 12) {
                    Text(pokemon.name.capitalized)
                        .font(.system(size: 40, weight: .black, design: .rounded))
                    
                    if let detail = pokemonVM.currentPokemonDetail {
                        HStack(spacing: 10) {
                            ForEach(detail.types, id: \.type.name) { t in
                                Text(t.type.name.uppercased())
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(typeColor(t.type.name)) // Aplicación de color
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                Divider().padding(.horizontal)

                // --- SECCIÓN DE DEBILIDADES ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("Debilidades (Daño x2)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    if pokemonVM.weaknesses.isEmpty {
                        HStack {
                            ProgressView()
                            Text("Analizando tipos...").font(.caption)
                        }
                    } else {
                        // Rejilla adaptable para las debilidades
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(pokemonVM.weaknesses, id: \.self) { weakness in
                                Text(weakness.capitalized)
                                    .font(.subheadline)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    // Fondo suave del color del tipo
                                    .background(typeColor(weakness).opacity(0.15))
                                    // Texto y borde del color del tipo
                                    .foregroundColor(typeColor(weakness))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(typeColor(weakness), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Carga automática de tipos y debilidades al entrar
            await pokemonVM.getDetailsAndWeaknesses(for: pokemon)
        }
    }
    
    // --- FUNCIÓN DE COLORES OFICIALES ---
    func typeColor(_ type: String) -> Color {
        switch type.lowercased() {
        case "fire": return .orange
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "psychic": return .pink
        case "poison": return .purple
        case "ghost": return Color(red: 0.45, green: 0.34, blue: 0.59)
        case "steel": return Color(red: 0.72, green: 0.72, blue: 0.81)
        case "ground": return .brown
        case "rock": return Color(red: 0.73, green: 0.62, blue: 0.23)
        case "ice": return Color(red: 0.59, green: 0.87, blue: 0.94)
        case "dragon": return Color(red: 0.44, green: 0.21, blue: 0.99)
        case "fairy": return .pink.opacity(0.6)
        case "bug": return Color(red: 0.65, green: 0.73, blue: 0.10)
        case "fighting": return Color(red: 0.76, green: 0.19, blue: 0.15)
        case "flying": return Color(red: 0.66, green: 0.58, blue: 0.93)
        case "normal": return .gray
        default: return .gray
        }
    }
}

//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dakota Riley on 4/2/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingResults = false
    
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var questionCounter = 1
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selectedFlag = -1
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy","Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                .padding(15)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ],center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack() {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .padding( 15)

                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: ( x:0, y:1, z:0 ))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                                .animation(.default, value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("Game Over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            let needsThe = ["UK", "US"]
            let answer = countries[number]
            
            if needsThe.contains(answer) {
                scoreTitle = "Wrong! That's the flag of the \(answer)"
            } else {
                scoreTitle = "Wrong! That's the flag of \(answer)"
            }
                        
            if score > 0 {
                score -= 1
            }
        }
        
        if questionCounter == 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
    
    func newGame() {
        questionCounter = 0
        score = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

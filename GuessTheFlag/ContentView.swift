//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dakota Riley on 4/2/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var isGameComplete = false
    @State private var scoreTitle = ""
    @State private var message = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy","Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var flagTappedCounter = 0
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
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
                        }
                        .padding(15)
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
            Text(message)
        }
        
        .alert(scoreTitle, isPresented: $isGameComplete) {
            Button("Restart", action: reset)
        } message: {
            Text("You completed the game. Your score is \(score) out of 8.")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            message = "Your score is \(score)"
        } else {
            message = "Wrong! That’s the flag of \(countries[number])."
            scoreTitle = "Wrong"
        }
        showingScore = true
        flagTappedCounter += 1
    }
    
    func reset() {
        score = 0
        flagTappedCounter = 0
        isGameComplete = false
        askQuestion()
    }
    
    func askQuestion() {
        if (flagTappedCounter == 8 ) {
            isGameComplete = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

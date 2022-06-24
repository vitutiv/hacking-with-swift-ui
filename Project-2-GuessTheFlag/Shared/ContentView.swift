//
//  ContentView.swift
//  Shared
//
//  Created by Victor on 03/06/22.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

struct FlagImage: View {
    var flag: String
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria",
                     "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var currentQuestion = 1
    @State private var gameOver = false
    @State private var score = 0
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.blue, .teal, .teal, .blue]), center: .center)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Spacer()
                    Text("Guess The Flag")
                        .titleStyle()
                }

                VStack(spacing: 15) {
                    Text(localized("Tap flag of"))
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))
                    Text(localized(countries[correctAnswer]))
                        .font(.largeTitle.weight(.semibold))
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: countries[number])
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("\(localized("Score")): \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button(localized("Continue"), action: askQuestion)
            } message: {
                Text("\(localized("Your score is")) \(score)")
            }.padding()

        } .alert("\(localized("Game over"))", isPresented: $gameOver) {
            Button(localized("Restart"), action: restartGame)
        } message: {
            Text("\(localized("Your score is")) \(score)")
        }
     }
    
    func localized(_ key: String, translate: Bool = true) -> String {
        translate ? NSLocalizedString(key, comment: "") : key
    }
    
    func flagTapped(_ number: Int) {
        if (number == correctAnswer) {
            scoreTitle = localized("Correct")
            score += 1
        } else {
            scoreTitle = "\(localized("Wrong! That's the flag of")) \(localized(countries[number]))"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        if (currentQuestion == 8) {
            gameOver = true
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentQuestion += 1
    }
    
    func restartGame() {
        currentQuestion = 0
        gameOver = false
        score = 0
        askQuestion()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

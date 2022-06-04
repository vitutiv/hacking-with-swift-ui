//
//  ContentView.swift
//  Shared
//
//  Created by Victor on 29/05/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 0
    @FocusState private var amountIsFocused: Bool
    private let currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "BRL")
    
    private var tipValue: Double {
        let tipSelection = Double(tipPercentage)
        return checkAmount * tipSelection / 100
    }

    private var totalAmount: Double {
       checkAmount + tipValue
    }
    
    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = totalAmount / peopleCount
        return amountPerPerson
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount",
                      value: $checkAmount,
                      format: .currency(code: Locale.current.currencyCode ?? "BRL")
                    ).keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0 ..< 101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.automatic)
                } header: {
                    Text("How much do you want to leave?")
                }
                Section {
                    Text(totalPerPerson, format: currencyFormat)
                } header: {
                    Text("Amount per person")
                }
                Section {
                    Text(totalAmount, format: currencyFormat)
                }header: {
                    Text("Total amount")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup (placement: .keyboard) {
                    Spacer()
                    Button ("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

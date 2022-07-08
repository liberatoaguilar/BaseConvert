//
//  ContentView.swift
//  BaseConvert
//
//  Created by Liberato Aguilar on 6/22/22.
//

import SwiftUI

let digitArr = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
let digits: [String.Element: Int] = [
    "0":0,
    "1":1,
    "2":2,
    "3":3,
    "4":4,
    "5":5,
    "6":6,
    "7":7,
    "8":8,
    "9":9,
    "a":10,
    "b":11,
    "c":12,
    "d":13,
    "e":14,
    "f":15,
    "g":16,
    "h":17,
    "i":18,
    "j":19,
    "k":20,
    "l":21,
    "m":22,
    "n":23,
    "o":24,
    "p":25,
    "q":26,
    "r":27,
    "s":28,
    "t":29,
    "u":30,
    "v":31,
    "w":32,
    "x":33,
    "y":34,
    "z":35,
]
    

func toBase10(fromBase: Int, num: String) -> Int {
    var base10: Int = 0
    var baseCount: Int = 1
    for d in num.lowercased().reversed() {
        var result = baseCount.multipliedReportingOverflow(by: digits[d] ?? 0)
        if (result.overflow) {
            base10 = Int.max
            break
        }
        result = base10.addingReportingOverflow(result.partialValue)
        if (result.overflow) {
            base10 = Int.max
            break
        }
        base10 = result.partialValue
        result = baseCount.multipliedReportingOverflow(by: fromBase)
        if (result.overflow) {
            base10 = Int.max
            break
        }
        baseCount = result.partialValue
    }
    return base10
}

func fromBase10(toBase: Int, num: Int) -> String {
    var newBase: String = ""
    var numCopy: Int = num
    while numCopy != 0 {
        newBase += String(digitArr[numCopy % toBase])
        numCopy /= toBase
    }
    return String(newBase.reversed())
}

func validateDigits(fromBase: Int, digits: String) -> Bool {
    var allowedDigs: String = ""
    for d in 0..<fromBase {
        allowedDigs += digitArr[d]
    }
    let filtered = digits.lowercased().filter { allowedDigs.contains($0) }
    return filtered == digits.lowercased()
}

struct ContentView: View {
    
    @State private var base1:Float = 10.0
    @State private var base2:Float = 2.0
    @State private var digits1 = ""
    @FocusState private var digitsFocused1: Bool
    
    var digits2: String {
        if validateDigits(fromBase: Int(self.base1), digits: digits1) {
            return fromBase10(toBase: Int(self.base2), num: toBase10(fromBase: Int(self.base1), num: self.digits1))
        } else {
            return ""
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Choose First Base: \(Int(base1))")
                    Slider(value: $base1, in: 2...36, step: 1)
                    TextField("Enter Digits: ", text: $digits1)
                        .focused($digitsFocused1)
                }
                
                Section {
                    Text("Choose Second Base: \(Int(base2))")
                    Slider(value: $base2, in: 2...36, step: 1)
                }
                
                Section {
                    Text("Result: \(digits2)")
                }
            }
            .navigationTitle("Base Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        digitsFocused1 = false
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

import Foundation

/// Data

guard let inputURL = Bundle.main.url(forResource: "Input", withExtension: nil) else {
    fatalError("Can't find input")
}

guard let inputData = try? Data(contentsOf: inputURL) else {
    fatalError("Can't find input data")
}

guard let input = String(data: inputData, encoding: .utf8) else {
    fatalError("Can't produce input string from data")
}

func getInputValues(fromInput input: String) -> [Int] {
    return Array(input
        .split(separator: "\n")
        .lazy
        .compactMap { Int($0) })
}

let inputValues = getInputValues(fromInput: input)

/// First Puzzle

func getFinalFrequency(inputValues: [Int]) -> Int {
    return inputValues
        .reduce(0, +)
}

let firstPuzzleSolution = getFinalFrequency(inputValues: inputValues)

print("First Puzzle solution: \(firstPuzzleSolution)")

/// Second Puzzle

struct FrequencyChangeStep {
    private var currentFrequency: Int
    private var seenFrequencies: Set<Int>
    private(set) var repeatedFrequency: Int?
    
    static let initial = FrequencyChangeStep(
        currentFrequency: 0,
        seenFrequencies: [0],
        repeatedFrequency: nil)
    
    mutating func advance(fromChange change: Int) {
        guard repeatedFrequency == nil else {
            return
        }

        currentFrequency += change
        
        guard seenFrequencies.contains(currentFrequency) else {
            seenFrequencies.insert(currentFrequency)
            return
        }
        
        repeatedFrequency = currentFrequency
    }
}

func getFirstRepeatedFrequency(inputValues: [Int], startingStep: FrequencyChangeStep) -> Int {
    
    let endingStep = inputValues
        .reduce(into: startingStep) { $0.advance(fromChange: $1) }
    
    return endingStep.repeatedFrequency
        ?? getFirstRepeatedFrequency(
            inputValues: inputValues,
            startingStep: endingStep)
}

let secondPuzzleSolution = getFirstRepeatedFrequency(
    inputValues: inputValues,
    startingStep: .initial)

print("Second Puzzle solution: \(secondPuzzleSolution)")

/// TESTS

let test_0_1_input =
"""
+1
-1
+2
-3
"""
let test_0_1_expected = [1, -1, 2, -3]
assert(getInputValues(
    fromInput: test_0_1_input)
    == test_0_1_expected)

let test_1_1_input =
"""
+1
-1
+2
-3
"""
let test_1_1_expected = -1
assert(getFinalFrequency(
    inputValues: getInputValues(fromInput: test_1_1_input))
    == test_1_1_expected)

let test_1_2_input =
"""
-7
-1
"""
let test_1_2_expected = -8
assert(getFinalFrequency(
    inputValues: getInputValues(fromInput: test_1_2_input))
    == test_1_2_expected)

let test_1_3_input =
"""
-9
+1
+21
-5
-2
+1
-1
+1
-1
"""
let test_1_3_expected = 6
assert(getFinalFrequency(
    inputValues: getInputValues(fromInput: test_1_3_input))
    == test_1_3_expected)

let test_2_1_input =
"""
+1
-1
+2
-3
"""
let test_2_1_expected = 0
assert(getFirstRepeatedFrequency(
    inputValues: getInputValues(fromInput: test_2_1_input),
    startingStep: .initial)
    == test_2_1_expected)

let test_2_2_input =
"""
+5
-6
+10
-8
+5
-7
"""
let test_2_2_expected = -1
assert(getFirstRepeatedFrequency(
    inputValues: getInputValues(fromInput: test_2_2_input),
    startingStep: .initial)
    == test_2_2_expected)

let test_2_3_input =
"""
+1
+2
+3
+4
-12
"""
let test_2_3_expected = 1
assert(getFirstRepeatedFrequency(
    inputValues: getInputValues(fromInput: test_2_3_input),
    startingStep: .initial)
    == test_2_3_expected)

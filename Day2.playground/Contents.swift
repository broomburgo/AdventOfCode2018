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

func getInputValues(fromInput input: String) -> [String] {
    return Array(input
        .split(separator: "\n")
        .map(String.init))
}

let inputValues = getInputValues(fromInput: input)

/// First Puzzle

func fromInout<A>(_ transform: @escaping (inout A) -> ()) -> (A) -> A {
    return { a in
        var m_a = a
        transform(&m_a)
        return m_a
    }
}

extension Dictionary {
    mutating func modify(at key: Key, start: Value, transform: (Value) -> Value) {
        guard let value = self[key] else {
            self[key] = start
            return
        }
        
        self[key] = transform(value)
    }
}

extension Sequence where Iterator.Element: Hashable {
    func getFrequencies() -> [Iterator.Element: Int] {
        return reduce(into: [Iterator.Element: Int]()) { result, element in
            result.modify(at: element, start: 1) { $0 + 1 }
        }
    }
}

extension Dictionary where Value: Hashable {
    func invertedKeyValues() -> [Value: [Key]] {
        return reduce(into: [Value: [Key]]()) { result, element in
            result.modify(at: element.value, start: [element.key], transform: fromInout { $0.append(element.key) })
        }
    }
}

func getChecksum(inputValues: [String]) -> Int {
    func getIncrement<A>(_ dict: [Int: [A]]) -> (twoOfAny: Int, threeOfAny: Int) {
        return (
            twoOfAny: (dict[2] ?? []).isEmpty ? 0 : 1,
            threeOfAny: (dict[3] ?? []).isEmpty ? 0 : 1
        )
    }
    
    let (twoOfAny, threeOfAny) = inputValues
        .lazy
        .map { $0.getFrequencies() }
        .map { $0.invertedKeyValues() }
        .map(getIncrement)
        .reduce(into: (0, 0)) { accumulation, element in
            accumulation.0 += element.twoOfAny
            accumulation.1 += element.threeOfAny
    }
    
    return twoOfAny * threeOfAny
}

let firstPuzzleSolution = getChecksum(inputValues: inputValues)

/// First Puzzle Tests

let test_1_inputValues = [
    "abcdef",
    "bababc",
    "abbcde",
    "abcccd",
    "aabcdd",
    "abcdee",
    "ababab"
]
let test_1_expectedSolution = 12
let test_1_solution = getChecksum(inputValues: test_1_inputValues)
assert(test_1_solution == test_1_expectedSolution)

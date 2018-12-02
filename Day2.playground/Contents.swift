import Foundation

guard let inputURL = Bundle.main.url(forResource: "Input", withExtension: nil) else {
    fatalError("Can't find input")
}

guard let inputData = try? Data(contentsOf: inputURL) else {
    fatalError("Can't find input data")
}

guard let input = String(data: inputData, encoding: .utf8) else {
    fatalError("Can't produce input string from data")
}

print(input)

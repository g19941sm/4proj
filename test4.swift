import Foundation
func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}

    let filename = "test.txt"
    var contents: String
    guard let fileContents = try? String(contentsOfFile: filename) else {
    fatalError("ファイル読み込みエラー")
    }
    let lines = fileContents.split(separator:"\n")
    for line in lines{
    let elements = line.split(separator:",")
    //shell("ffmpeg -ss \(elements[1])  -i 0721.mov -t 4 -c copy \(elements[0]).mov")
    
    }

// ランダムに並べたまとめ動画
import Foundation
import AppKit
import Photos
import ImageIO

var fileNames = [String]()
var shootingTime = [String]()
var shootingDate = "0929"

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

func getFileInfoListInDir(_ dirName: String) -> [String] {
    let fileManager = FileManager.default
    var files: [String] = []

    do {
        files = try fileManager.contentsOfDirectory(atPath: dirName)
        let results = files.filter({ $0.contains("JPG") }) //["image8.JPG", "image7.JPG", "image6.JPG", "image4.JPG", "image5.JPG", "image1.JPG", "image2.JPG", "image3.JPG"]
        let resultscounts = results.count //8
        return results
        } catch {
        return files
    }
    return files
}

func getExif(_ dirName: String)  -> String {
    let path = dirName
    let url = URL(fileURLWithPath: path)
    let image = CIImage(contentsOf: url)
    let properties: [String: Any] = image!.properties
    let exif = properties["{Exif}"] as! [String: Any]
    let dateTimeOriginal = exif[kCGImagePropertyExifDateTimeOriginal as String] as! String
    return String(dateTimeOriginal)
}


for count in 1...getFileInfoListInDir("0929").count{
   shell("ffmpeg -loop 1 -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/image\(count).JPG -vcodec libx264 -pix_fmt yuv420p -t 3 -r 23.98 -s 1920x1080 -aspect \"16:9\" /Users/sotomuramana/Documents/4proj/\(shootingDate)/image\(count).mov")
   fileNames.append("image\(count).mov")
   shootingTime.append(getExif("/Users/sotomuramana/Documents/4proj/\(shootingDate)/image\(count).JPG"))
}

func getShootingTime() {
    let filename2 = "/Users/sotomuramana/Documents/4proj/0929/test2.txt"

    guard let fileContents2 = try? String(contentsOfFile: filename2) else {
    fatalError("ファイル読み込みエラー")
    }

    let lines2 = fileContents2.split(separator:"\n")
    for line in lines2{
    let elements2 = line.split(separator:",")
    fileNames.append("\(String(elements2[0])).mov")
    shootingTime.append(String(elements2[1]))
}
}

getShootingTime()

    let filename = "/Users/sotomuramana/Documents/4proj/0929/test.txt"
    var contents: String
    var time: [String] = []
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "m:ss"
    var n: Int = 0
    var i: Int = 0
    guard let fileContents = try? String(contentsOfFile: filename) else {
    fatalError("ファイル読み込みエラー")
    }

    let lines = fileContents.split(separator:"\n")
    for line in lines{
    let elements = line.split(separator:",") //elements[1]に秒数,elements[0]にいいねポイントなど
    let Str = String(elements[1]) //elements[1]をstring型に変換
    let date = dateformatter.date(from: Str)! //date型に変換
    let date2 = Date(timeInterval: -2, since: date) //-2秒した時刻を取得

    shell("ffmpeg -ss \(dateformatter.string(from: date2))  -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/\(shootingDate).mov -t 4 -vcodec libx264 /Users/sotomuramana/Documents/4proj/\(shootingDate)/\(elements[0]).mov")

    if elements[0].contains("きゅん"){ //きゅんきゅんポイントが出てきた回数nを調べる
    n += 1
    }
    }

    for count in 1...n {
    shell("ffmpeg -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/きゅんきゅんポイント\(count).mov -i heart.mov -filter_complex \"[1:0]colorkey=black:0.01:1[colorkey];[0:0][colorkey]overlay=x=(W-w)/2:y=(H-h)/2\" -preset ultrafast /Users/sotomuramana/Documents/4proj/\(shootingDate)/きゅんポイント\(count).mov")
    }

    func createFile(_ fileName: String) -> Bool {
        let fileManager = FileManager.default
        let result = fileManager.createFile(atPath: fileName, contents: nil, attributes: nil)
        return result
    }


    func writeTextFile(text: String) {
    let fileName = "/Users/sotomuramana/Documents/4proj/\(shootingDate)/list2.txt"
    let contentString = text
    let file = FileHandle(forWritingAtPath: fileName)!
    let contentData = contentString.data(using: .utf8)!
    file.seekToEndOfFile()
    file.write(contentData)
    file.closeFile()
    }

    let hoge = fileNames.enumerated().compactMap {$0.1.contains("きゅん") ? $0.0 : nil}
    for num in hoge {
    i += 1
    fileNames[num] = "きゅんポイント\(i).mov"
    }

    //createFile("/Users/sotomuramana/Documents/4proj/\(shootingDate)/list2.txt")
    for file in fileNames.shuffled() {
    writeTextFile(text: "file \'")
    writeTextFile(text: file)
    writeTextFile(text: "\'")
    writeTextFile(text: "\n")
    }

    shell("ffmpeg -f concat -safe 0 -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/list2.txt /Users/sotomuramana/Documents/4proj/\(shootingDate)/matome2.mov")

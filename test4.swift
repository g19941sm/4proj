import Foundation
import AppKit
import Photos
import ImageIO

var fileNames = [String]()
var shootingTime = [String]()
var shootingDate = "1027"

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

for count in 1...getFileInfoListInDir(shootingDate).count{ //静止画を動画に変換
   //shell("ffmpeg -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/image\(count).JPG -vcodec libx264 -r 23.98 -vf \"zoompan=z=\'min(zoom+0.0015,1.5)\':d=\'25*4\':x=\'iw/2-(iw/zoom/2)\':y=\'ih/2-(ih/zoom/2)\'\" -s 1920x1080 -aspect \"16:9\" /Users/sotomuramana/Documents/4proj/\(shootingDate)/image\(count).avi")
   fileNames.append("image\(count).avi")
   shootingTime.append(getExif("/Users/sotomuramana/Documents/4proj/\(shootingDate)/image\(count).JPG"))
}

func getShootingTime() {
    let filename2 = "/Users/sotomuramana/Documents/4proj/\(shootingDate)/test2.txt"

    guard let fileContents2 = try? String(contentsOfFile: filename2) else {
    fatalError("ファイル読み込みエラー")
    }

    let lines2 = fileContents2.split(separator:"\n")
    for line in lines2{
    let elements2 = line.split(separator:",")
    fileNames.append("\(String(elements2[0])).avi")
    shootingTime.append(String(elements2[1]))
}
}

getShootingTime()

    let filename = "/Users/sotomuramana/Documents/4proj/\(shootingDate)/test.txt"
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

    //shell("ffmpeg -ss \(dateformatter.string(from: date2))  -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/\(shootingDate).mov -t 4 -vcodec libx264 /Users/sotomuramana/Documents/4proj/\(shootingDate)/\(elements[0]).avi")

    if elements[0].contains("きゅん"){ //きゅんきゅんポイントが出てきた回数nを調べる
    n += 1
    }
    }

    for count in 1...n {
    //shell("ffmpeg -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/きゅんきゅんポイント\(count).avi -i heart.mov -vcodec libx264 -filter_complex \"[1:0]colorkey=black:0.01:1[colorkey];[0:0][colorkey]overlay=x=(W-w)/2:y=(H-h)/2\" -preset ultrafast /Users/sotomuramana/Documents/4proj/\(shootingDate)/きゅんポイント\(count).avi")
    }

    func createFile(_ fileName: String) -> Bool {
        let fileManager = FileManager.default
        let result = fileManager.createFile(atPath: fileName, contents: nil, attributes: nil)
        return result
    }


    func writeTextFile(text: String) {
    let fileName = "/Users/sotomuramana/Documents/4proj/\(shootingDate)/list.txt"
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
    fileNames[num] = "きゅんポイント\(i).avi"
    }

    var formattedDateArray = [Date]()
    for date in shootingTime {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
    formatter.locale = Locale(identifier: "ja_JP")
    formattedDateArray.append(formatter.date(from: date)!)
    }

    let dateSorted = formattedDateArray.enumerated().sorted { $0.element < $1.element }

    //createFile("/Users/sotomuramana/Documents/4proj/\(shootingDate)/list.txt")
    for (index, element) in dateSorted {
    //writeTextFile(text: "file \'")
    //writeTextFile(text: fileNames[index])
    //writeTextFile(text: "\'")
    //writeTextFile(text: "\n")
    }

    //shell("ffmpeg -f concat -safe 0 -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/list.txt /Users/sotomuramana/Documents/4proj/\(shootingDate)/concat.mov")

    func getDuration() -> String { //まとめ動画の長さ取得
      return shell("ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 /Users/sotomuramana/Documents/4proj/\(shootingDate)/concat.mov")
    }

    let duration = getDuration().trimmingCharacters(in: .newlines)
    let v_st = Double(duration)! - 1
    let a_st = Double(duration)! - 5
    shell("ffmpeg -i /Users/sotomuramana/Documents/4proj/\(shootingDate)/concat.mov -i audio.mp3 -vf \"fade=t=in:st=0:d=1,fade=t=out:st=\(v_st):d=1\" -filter_complex \"[1:a]afade=t=in:st=0:d=5,afade=t=out:st=\(a_st):d=5[a]\" -map 0:v:0 -map \"[a]\" -t \(duration) /Users/sotomuramana/Documents/4proj/\(shootingDate)/matome.mov")

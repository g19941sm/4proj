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

func getFileInfoListInDir(_ dirName: String) -> [String] {
    let fileManager = FileManager.default
    var files: [String] = []

    do {
        files = try fileManager.contentsOfDirectory(atPath: dirName)
        let results = files.filter({ $0.contains("image") }) //["image8.JPG", "image.mov", "image7.JPG", "image6.JPG", "image4.JPG", "image5.JPG", "image1.JPG", "image2.JPG", "image3.JPG"]
        let resultscounts = results.count //9
        return results
        } catch {
        return files
    }
    return files
}

for count in 1...getFileInfoListInDir("0827").count{
    //shell("ffmpeg -loop 1 -i /Users/sotomuramana/Documents/4proj/0827/image\(count).JPG -vcodec libx264 -pix_fmt yuv420p -t 3 -r 23.98 -s 1920x1080 -aspect \"16:9\" image\(count).mov")
}

func writeTextFile(filecontents: String) {
        let path = NSHomeDirectory() + "/Documents/4proj/list.txt"
        let text = filecontents

        do {
            // テキストの書き込みを実行
            try text.write(toFile: path, atomically: true, encoding: .utf8)
            print("成功\nopen ", path)
        } catch {
            //　テストの書き込みに失敗
            print("失敗:", error )
        }
}

writeTextFile(filecontents: "アイウエオ")
writeTextFile(filecontents: "かきくけこ")

    let filename = "test.txt"
    var contents: String
    var time: [String] = []
    var text: [String] = []
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "m:ss"
    var n: Int = 0
    guard let fileContents = try? String(contentsOfFile: filename) else {
    fatalError("ファイル読み込みエラー")
    }


    let lines = fileContents.split(separator:"\n")
    for line in lines{
    let elements = line.split(separator:",") //elements[1]に秒数,elements[0]にいいねポイントなど
    text.append(String(elements[0]))
    let Str = String(elements[1]) //elements[1]をstring型に変換
    let date = dateformatter.date(from: Str)! //date型に変換
    let date2 = Date(timeInterval: -2, since: date) //-2秒した時刻を取得

    //shell("ffmpeg -ss \(dateformatter.string(from: date2))  -i 0827.mov -t 4 -vcodec libx264 \(elements[0]).mov")
    if elements[0].contains("きゅん"){ //きゅんきゅんポイントが出てきた回数nを調べる
    n += 1
    }
    }
    for count in 1...n {
    //shell("ffmpeg -i きゅんきゅんポイント\(count).mov -i heart.mov -filter_complex \"[1:0]colorkey=black:0.01:1[colorkey];[0:0][colorkey]overlay=x=(W-w)/2:y=(H-h)/2\" -preset ultrafast きゅんポイント\(count).mov")
    }

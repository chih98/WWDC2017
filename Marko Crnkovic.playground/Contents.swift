//: That's music to my ears.
//: It's time to make music, and art from prose. How? With a little help from a very special field called mathamagic!

import UIKit
import PlaygroundSupport
import AudioToolbox


// =====================================


//  IF ON macOS MAKE SURE ASSISTANT EDITOR IS OPEN


// =====================================

// Choose from what text you want the magic to grow from by commenting and uncommenting a line of code. You can add your own txt file!

// let fileName = "Apple-Event"

 let fileName = "Hamlet"

//let fileName = "Lorem-Ipsum"

/* It is cool how a different "language" sounds so differently! */

// let fileName = "/Custom/File/Path"


let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt")

let file = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let words = Array(file.components(separatedBy: " "))

// Now all the words are seperate objects in an array, and can be worked with!

// Time to create the view and add the text box

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

view.backgroundColor = UIColor.gray

let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))

label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
label.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
label.textAlignment = .center

label.text = words[0]
label.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]

view.addSubview(label)




PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view

// Change Color takes the number and assigns a color to each part of the number. i.e. With 325, red = 0.3, blue = 0.2 and green = 0.5. Alpha is always 1.
func changeColor(_ word: String) -> UIColor {
    
    let score = UInt32(scorer(word))
    
    var r: Float32 = 0
    var g: Float32 = 0
    var b: Float32 = 0
    
    if score < 10 {
        
        r = Float32(score) / 10
        g = Float32(score) / 10
        b = Float32(score) / 10
        
    } else if score < 100 {
        
        let scoreWord = String(score)
        
        let firstNumber = Int("\(scoreWord.characters.first!)")
        
        let lastNumber = Int("\(scoreWord.characters.last!)")
        
        r = Float32(firstNumber!) / 10
        g = Float32(lastNumber!) / 10
        b = Float32(firstNumber!) / 10
    
        
    } else if score < 1000 {
        
        let scoreWord = String(score)
        
        let firstNumber = Int("\(scoreWord.characters.first!)")
        
        let a = word.index(after: scoreWord.startIndex)
        let secondNumber = Int("\(scoreWord[a])")
        
        let thirdNumber = Int("\(scoreWord.characters.last!)")
     
        
        r = Float32(firstNumber!) / 10
        g = Float32(secondNumber!) / 10
        b = Float32(thirdNumber!) / 10
        
        
    } else {
        
        r = 1
        g = 1
        b = 1
    
    }
    
    return UIColor(colorLiteralRed: Float(r),
                                    green: Float(g),
                                    blue: Float(b),
                                    alpha: 1)

}

// Play tone takes the word, and a time interval, and plays a tone based on the score of the word. Due to the limited range of the tones, if a word is a little high or low in regards to the range, some math is done to rebound the tone back into an audible range. This still leaves the possibility to hear outliers. They will either be a very high pitched or low, almost inaudiable tone.
func playTone(_ word: String, timeInterval: Float) {
    
    
    // Creating the sequence
    
    var sequence:MusicSequence? = nil
    _ = NewMusicSequence(&sequence)
    
    // Making a track
    
    var track:MusicTrack? = nil
    var musicTrack = MusicSequenceNewTrack(sequence!, &track)
    
    musicTrack;
    
    // Making note
    
    var tone: UInt8 = 64
    
    let score = Float(scorer(word))

    if score < 10 {
        let a: Float = score / 10
        let b: Float = a * 116
        tone = UInt8(b)
    } else if score < 100 {
        let a: Float = score / 100
        let b: Float = a * 116
        tone = UInt8(b)
    } else if score < 1000 {
        let a: Float = score / 1000
        let b: Float = a * 116
        
        if b < 45 {
            
            let c = 45 + b
            tone = UInt8(c)
        } else {
            tone = UInt8(b)
        
        }
    } else {
        tone = 116
    }
    
    
    // Generating time signature and the actual playable note
    let time = MusicTimeStamp(timeInterval)
    
    var note = MIDINoteMessage(channel: 0, note: tone, velocity: 255, releaseVelocity: 0, duration: timeInterval)
    musicTrack = MusicTrackNewMIDINoteEvent(track!, time, &note)
    
    
    
    
    // Creating the player
    
    var musicPlayer:MusicPlayer? = nil
    var player = NewMusicPlayer(&musicPlayer)
    player;
    player = MusicPlayerSetSequence(musicPlayer!, sequence)
    player = MusicPlayerStart(musicPlayer!)
    

}

// Scorer takes the word including special charactars and then calulates the value of the word based on the length, and ascii values of all characters. Special characters (like commas, and dashes) are included, because if a word is at the end of a clause, it usually is more significant than a word that is in the middle of one.
func scorer(_ word: String) -> UInt32 {
    var score: UInt32 = 0
    score = UInt32(word.characters.count)
    
    for i in 0...word.characters.count {
        
        // NOTE: endnote 1
        score += (String(i).unicodeScalars.filter{$0.isASCII}.first?.value)!
        
    }
    
    return score
}


// Here is where all the fun happens! Counter is the running index, whilie this first if clause is to determine the initial duration of the loop. Then in the loop, all the above functions are called and it calculates everything for the next iteration.
var counter = 0

let scoree = scorer(words[counter])

var timeInterval: Float = 0.5

if scoree < 10 {
    timeInterval = Float(scoree) / Float(10)
} else if scoree < 100 {
    timeInterval = Float(scoree) / Float(100)
} else if scoree < 1000 {
    timeInterval = Float(scoree) / Float(1000)
}

let time = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: true) { (time) in
    
    let score = scorer(words[counter + 1])
    
    if score < 10 {
        timeInterval = Float(score) / Float(10)
    } else if score < 100 {
        timeInterval = Float(score) / Float(100)
    } else if score < 1000 {
        timeInterval = Float(score) / Float(1000)
    }
    
    
    
    let word = words[counter]
    label.text = word
    counter += 1
 
    let bg = changeColor(word)
    
    playTone(word, timeInterval: timeInterval)
    
    UIView.animate(withDuration: TimeInterval(timeInterval), delay: 0, options: .allowAnimatedContent, animations: {
        view.backgroundColor = bg
    }, completion: nil)
    
    if counter == words.count {
        time.invalidate()
    }
}


/* ------- ENDNOTES --------
As with any academical paper, credit should be given where credit is due.
 
 1. http://stackoverflow.com/questions/29835242/whats-the-simplest-way-to-convert-from-a-single-character-string-to-an-ascii-va
 
 
 
*/


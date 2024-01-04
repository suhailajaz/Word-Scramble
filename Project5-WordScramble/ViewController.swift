//
//  ViewController.swift
//  Project5-WordScramble
//
//  Created by suhail on 04/07/23.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(WordCellTableViewCell.nib, forCellReuseIdentifier: WordCellTableViewCell.identifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Word", image: nil, target: self, action: #selector(startGame))
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty{
            allWords = ["Homelander"]
        }
        startGame()
    }
    
    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WordCellTableViewCell.identifier, for: indexPath) as! WordCellTableViewCell
        cell.lblCurrentWord.text = usedWords[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func promptForAnswer(){
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else{ return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac,animated: true)
        
    }
    
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isLongEnough(word: lowerAnswer){
                    if isReal(word: lowerAnswer){
                        usedWords.insert(lowerAnswer,at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        
                        return
                    }else{
                        errorTitle = "Word not recognised"
                        errorMessage = "You cannot just make them up, you know!"
                        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                    }
                }else{
                    errorTitle = "Word problem"
                    errorMessage = "The word needs to be atleast three characters long and must not be same as the title!"
                    showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                }
            }else{
                errorTitle = "Word already used"
                errorMessage = "Be more original!"
                showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
            }
        }else{
            
            errorTitle = "Word not possible"
            errorMessage = "You cannot spell that word from \(title!.lowercased())."
            showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
        
        
    }
    func isLongEnough(word:String)-> Bool{
        if word.count>=3 && word != title{
            return true
        }else{
            return false
        }
        
    }
    func isPossible(word: String) -> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word{
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
            
        }
        return true
        
    }
    func isOriginal(word: String) -> Bool{
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool{
        //checking if a word is a valid english language word
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String,errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac,animated: true)
    }
}


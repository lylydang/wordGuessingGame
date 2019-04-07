//
//  ViewController.swift
//  WordGuessing
//
//  Created by Ly Ly Dang on 3/30/19.
//  Copyright © 2019 DeAnza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let maxTries: Int = 6 //maximum number of tries allowed per game
    var triesLeft: Int = 0 //the number of tries left that the player has
    var incorrectList = [String]()  //array to store incorrect letters that the player guesses
    var underscoredWord = [Character]()  //stores the hidden word as underscores for word length
    var levelOfDiffculty: String = "1" //the difficulty level of the game
    var secretWord = ""  //the secret word that the player is trying to guess

    //Popup for setting the difficulty level
    @IBAction func showPopup(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopupID") as! PopupViewController
        
        popOverVC.parentVC = self
        
        self.addChild(popOverVC) //this will add popOverVC to the current viewcontroller
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
    }

    @IBOutlet var secretWordLabel: UILabel!
    @IBOutlet var userInput: UITextField!
    @IBOutlet var pressBtn: UIButton!
    @IBOutlet weak var triesLeftMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetGame() // reset the game at the very beginning
    }
    
    @IBAction func pressBtnAction(_ sender: Any) {
    
        //turn userInput into lowercase as game is not case sensitive
        userInput.text = userInput.text?.lowercased()
        
        //check to see if the user input is valid
        if validateInput(inputString: userInput.text!) == true {
            updateTriesLeftDisplay(numberOfTriesLeft: triesLeft) //display the tries left at the beginning
            
            //check if the user input is in the secret word
            if secretWord.contains(userInput.text!){ //the player's guess is correct
                
                displayCorrectChars() //reveal the correct letters to the user
                checkIfWon() //check if the user won
                
            } else { //the player's guess is incorrect
                
                triesLeft -= 1 //decrease the tries number
                incorrectList.append(userInput.text!) //add the incorrect letter to the incorrect letters list for display
                
                //display the warning wrong guess
                let clickAlert = UIAlertController(title: "Wrong guess :(", message: ("Your guess is wrong, please try again!"), preferredStyle: UIAlertController.Style.alert)
                clickAlert.addAction((UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,
                                                    handler: {(alert: UIAlertAction!) in self.checkGameOver()})))  //check if the game is over when user clicks OK
                self.present(clickAlert, animated: true, completion: nil)
                
                updateTriesLeftDisplay(numberOfTriesLeft: triesLeft) //update the tries left since user entered a wrong guess
            }
        }
        
        userInput.text = "" //let's clear the input after the player guesses
    
    }
    
    //Display hidden word in underscores function
    func resetSecretWordLabel(){
        for _ in secretWord {
            underscoredWord.append("_")
            underscoredWord.append(" ")
        }
        self.secretWordLabel.text  = String(underscoredWord)
        
    }
    
    //Add a spinner view to the current view
    func createSpinnerView() {
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // wait 0.5s before resetting the underscoredWord and its display
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            self.underscoredWord = [] //reset the underscoredWord
            self.resetSecretWordLabel() //reset the secret word label to underscores
            
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    //Display correct letter while the rest hidden
    func displayCorrectChars() {
        let letter = userInput.text!
        let letterArray = Array(letter)

        var index: Int = 0
        for char in secretWord { //for each character in the secret word
            if letterArray[0] == char { // if the user input is equal to the character
                underscoredWord[index*2] = letterArray[0]  //replace the underscore with the user input, index*2 to skip the spaces
            }
            index += 1
        }
        self.secretWordLabel.text  = String(underscoredWord)

    }
    
    //Display a congrats popup when the player wins
    func checkIfWon() {
        if !(underscoredWord.contains("_")){  //check if there is any _ left in the underscoredWord
            
            let clickAlert = UIAlertController(title: "Congrats!!!", message: ("You guessed the correct word!"), preferredStyle: UIAlertController.Style.alert)
            clickAlert.addAction((UIAlertAction(title: "New Game", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                self.resetGame()  //reset the game when the player wins
                
            })))
            self.present(clickAlert, animated: true, completion: nil)
        }
    }
    
    //Reset the game
    func resetGame() {
        
        //add spinner view to allow enough time for the current view to reset while getting a word from the LinkedIn REACH API
        createSpinnerView()
        
        //get a new word from the API and set the secret word to this value
        self.getWordFromAPI(completion: { wordFromApi in
            print("Debug: wordFromApi is " + wordFromApi) //TODO: this is a debug statement for testing the game and should be removed when the interview is over :)
            self.secretWord = wordFromApi
        })
        
        triesLeft = maxTries //reset the triesLeft to the maxTries
        incorrectList = [] //reset the incorrect characters list
        updateTriesLeftDisplay(numberOfTriesLeft: triesLeft) //update the display for the tries left and incorrect characters
    }
    
    //Function to validate user input string. Only allow a singer letter character to be used in the game.
    //Returns true for a valid input, false otherwise.
    func validateInput(inputString: String) -> Bool{
        if inputString.count == 1 {  //check if the input is 1 character
            if inputString.rangeOfCharacter(from: NSCharacterSet.letters) == nil {  //check if the input is a letter character
                
                //Display a warning message when the input is not a letter character
                let clickAlert = UIAlertController(title: "Invalid input", message: ("Please enter valid letter"), preferredStyle: UIAlertController.Style.alert)
                clickAlert.addAction((UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)))
                self.present(clickAlert, animated: true, completion: nil)
                
                return false //invalid input, return false
            }
            return true //input is valid, return true
        } else { //input is more than 1 character
            
            //Display a warning message when the input is more than 1 character
            let clickAlert = UIAlertController(title: "Invalid input", message: ("Input must be 1 letter"), preferredStyle: UIAlertController.Style.alert)
            clickAlert.addAction((UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)))
            self.present(clickAlert, animated: true, completion: nil)
            
            return false  //invalid input, return false
        }
    }

    //Check if the game is over. Game is over when the player has no tries left. This function will display an alert and force the Player to start a new game.
    func checkGameOver() {
        if(self.triesLeft == 0) {
            //display warning that the game is over
            let clickAlert = UIAlertController(title: "Game's Over", message: ("You ran out of guesses."), preferredStyle: UIAlertController.Style.alert)
            clickAlert.addAction((UIAlertAction(title: "New Game", style: UIAlertAction.Style.default,
                                                handler: { (alert: UIAlertAction!) in self.resetGame()}))) //reset the game
            self.present(clickAlert, animated: true, completion: nil)
        }
    }
    
    //Display updated tries left
    func updateTriesLeftDisplay(numberOfTriesLeft: Int) {
        self.triesLeftMsgLabel.text = "You have " + String(numberOfTriesLeft) + " tries left. \nAll incorrect values: " + incorrectList.joined(separator: ", ")
    }
    
    //Get a new word from the LinkedIn REST API. At completion, return the word from the API.
    func getWordFromAPI(completion: @escaping (String) -> ()) {
        var urlComp = URLComponents(string: "http://app.linkedin-reach.io/words")! //url for performing GET REST API call
        
        //parameters to be used with the REST API
        urlComp.queryItems = [URLQueryItem(name: "count", value: "1000"),
                              URLQueryItem(name: "difficulty", value: self.levelOfDiffculty)]
        
        //connect the URL session and perform request
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: urlComp.url!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {

                let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue) //convert raw data return from the API to an NSString
                
                let responseArray = response?.components(separatedBy: "\n") //separate the response string by a new line into a String Array
                let randomIndex = Int.random(in: 0...999) //get a random number between 0 and 999 to use as the index to pick a random word in the array
                
                completion(responseArray![randomIndex]) //return a random word
            }
        }
        task.resume()
    }
    
}

//
//  CheerMeUpViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 25.06.21.
//

import UIKit

class CheerMeUpViewController: UIViewController {
    let dispatchGroup = DispatchGroup()
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTitleLabel: UILabel!
    @IBOutlet weak var jokeLabel: UILabel!
    var memeArray = [String]()
    var memeTitle = ""
    var jokeString = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memeButton: UIButton!
    @IBOutlet weak var jokeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeButton.layer.borderColor = UIColor.black.cgColor
        memeButton.layer.borderWidth = 2
        memeButton.layer.cornerRadius = 10
        jokeButton.layer.borderColor = UIColor.black.cgColor
        jokeButton.layer.borderWidth = 2
        jokeButton.layer.cornerRadius = 10
        activityIndicator.color = UIColor.black
    }
    
    @IBAction func memeButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        fetchMeme()
        dispatchGroup.notify(queue: .main){
            self.activityIndicator.stopAnimating()
            self.memeImageView.isHidden = false
            self.memeTitleLabel.isHidden = false
            self.jokeLabel.isHidden = true
            var url = URL(string: "")
            if (self.memeArray.count - 1 > 2){
                url = URL(string: self.memeArray[3])
            }
            else{
                url = URL(string: self.memeArray[self.memeArray.count - 1])
            }
            let data = try? Data(contentsOf: url!)
            self.memeTitleLabel.isHidden = false
            self.memeTitleLabel.text = self.memeTitle
            self.memeImageView.image = UIImage(data: data!)
            self.memeImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func jokeButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        fetchJoke()
        dispatchGroup.notify(queue: .main){
            self.memeImageView.isHidden = true
            self.memeTitleLabel.isHidden = true
            self.jokeLabel.isHidden = false
            self.jokeLabel.text = self.jokeString
            self.activityIndicator.stopAnimating()
        }
    }
    
    func fetchMeme() {
        dispatchGroup.enter()
        guard let url = URL(string: "https://meme-api.herokuapp.com/gimme")else{return}
        URLSession.shared.dataTask(with: url, completionHandler: { data,response,error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            var result: Memes?
            do{
                result = try JSONDecoder().decode(Memes.self, from: data)
            }
            catch{
                print("failed to decode \(error)")
            }
            
            guard let json = result else{
                return
            }
            self.memeArray = json.preview
            self.memeTitle = json.title
            self.dispatchGroup.leave()
        }).resume()
    }
    
    func fetchJoke() {
        dispatchGroup.enter()
        guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw&type=single")else{return}
        URLSession.shared.dataTask(with: url, completionHandler: { data,response,error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            var result: Jokes?
            do{
                result = try JSONDecoder().decode(Jokes.self, from: data)
            }
            catch{
                print("failed to decode \(error)")
            }
            
            guard let json = result else{
                return
            }
            self.jokeString = json.joke
            self.dispatchGroup.leave()
        }).resume()
    }
}

struct Memes: Codable {
    let title: String
    let url: String
    let author: String
    let preview: [String]
}

struct Jokes: Codable {
    let joke: String
}

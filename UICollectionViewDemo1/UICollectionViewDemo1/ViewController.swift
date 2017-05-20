
//  ViewController.swift
//  UICollectionViewDemo1
//
//  Created by healer on 4/29/17.
//  Copyright © 2017 healer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var defaultSession: URLSession!
    var dataTask: URLSessionDataTask?
    
    
    var images = [String]()
    var titles = [String]()

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self,     delegateQueue: nil)
        
        requestData()
    }
    
    func requestData() {
        dataTask = defaultSession.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=24b1973f805d7f765ee59e3481812a29&language=en-US")!)
        
        dataTask?.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MyCollectionViewCell
        
        
        let url = URL(string: images[indexPath.row])
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.itemImageView.image = UIImage(data: data!)
                cell.lb.text = self.titles[indexPath.row]
            }
        }
        return cell
    }
}

extension ViewController: URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            //print(json["page"])
            let movieArray = json["results"] as! [Any]
            //            print(movieArray)
            for index in 0...19{
                let firstObject = movieArray[index] as! [String: Any]
                //print(firstObject["poster_path"])
                
                images.append("https://image.tmdb.org/t/p/w640/" + (firstObject["poster_path"] as! String))
                titles.append(firstObject["original_title"] as! String)
            }
            print(images)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            
        }
    }
}

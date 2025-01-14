//
//  ViewController.swift
//  Planner app
//
//  Created by user252544 on 3/28/24.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    var arrMotivationalPhotos = [UIImage(named: "1")!,UIImage(named: "2"),UIImage(named: "3")!,UIImage(named: "4")!]
    struct ImageData: Decodable {
        let images: [String]
    }

    

    func loadImages(completion: @escaping () -> Void) {
        let url = URL(string: "https://raw.githubusercontent.com/yourusername/your-repo/master/yourfile.json")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let imageData = try decoder.decode(ImageData.self, from: data)
                self.arrMotivationalPhotos = imageData.images.compactMap { (name: String) -> UIImage? in
                    return UIImage(named: name)
                }
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    var timer : Timer?
    var currentCellIndex = 0
     
    
    var models: [(title: String, note: String)] = []
    var mysoundfile: AVAudioPlayer!
        override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        title = "Motivational App"
            collectionView.delegate = self
            collectionView.dataSource = self
            pageControl.numberOfPages = arrMotivationalPhotos.count
            startTimer()
        
        //sound
        let SoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "happysound", ofType: "mp3")!)
        mysoundfile = try? AVAudioPlayer(contentsOf: SoundURL )
        
        setLabels()
            
    
        
    }
        func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
        
        
    }
    @objc func moveToNextIndex(){
        if currentCellIndex < arrMotivationalPhotos.count - 1{
            currentCellIndex += 1
        }else{
            currentCellIndex = 0
        }
        
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMotivationalPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.imgProductPhoto.image = arrMotivationalPhotos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //Events
    
    
    
    
    @IBAction func  didTapNewNote () {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            self.models.append((title: noteTitle, note: note))
            self.table.isHidden = false
            
            self.table.reloadData()
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //Table for notes
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        //show notes controller
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "note") as? NoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.title
        vc.note = model.note
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
    }
    ///sound function
    func setLabels() {
        mysoundfile.play()
    }
    
    
    
    
   

    }

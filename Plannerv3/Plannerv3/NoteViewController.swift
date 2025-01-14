//
//  NoteViewController.swift
//  Plannerv3
//
//  Created by user252544 on 3/28/24.
//

import UIKit


class NoteViewController: UIViewController {
    
    
    
    @IBOutlet var titlelabel: UILabel!
    @IBOutlet var notelabel: UITextView!
    
    public var noteTitle: String = " "
    public var note: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelabel.text = noteTitle
        notelabel.text = note

        
    }
    


}

//
//  DocumentViewController.swift
//  DocumentsCoreDataRelationships
//
//  Created by Brady Webb on 9/27/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var document: Document?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        if let document = document {
            let name = document.name
            nameTextField.text = name
            contentTextView.text = document.content
            title = name
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: Any) {
        let documentName = name.trimmingCharacters(in: .whitespaces)
        let content = contentTextView.text
        if document == nil {
            if
                let category = category {
                document = Document(name: documentName, content: content, category: category)
            }
        }
        else
        {
            if
                let category = category {
                document?.update(name: documentName, content: content, category: category)
            }
        }
        if
            let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            }
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nameChanged(_ sender: Any) {
        title = nameTextField.text
    }
    
}

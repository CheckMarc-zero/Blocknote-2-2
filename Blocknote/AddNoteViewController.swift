//
//  ViewController.swift
//  Blocknote
//
//  Created by Андрей Сигида on 01/10/2021.
//  Copyright © 2021 Андрей Сигида. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var titleNoteTextField: UITextField! 
    @IBOutlet weak var noteTextView: UITextView!
    
    private lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    var noteModel: NoteModel?
    
    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = noteModel?.screenTitle
        titleNoteTextField.text = noteModel?.noteTitle
        noteTextView.text = noteModel?.noteDescreption
        
        setResponder()
    }
    
    @IBAction func saveTapped (_sender:UIBarButtonItem) {
        guard let note = noteModel else {
            saveNote()
            navigationController?.popViewController(animated: true)
            return
        }
        
        context.delete(note.notes[note.indexNote])
        saveNote()
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setResponder() {
        if  noteModel == nil {
            titleNoteTextField.becomeFirstResponder()
        } else {
            noteTextView.becomeFirstResponder()
        }
    }
    
    private func saveNote() {
        let titleNote = titleNoteTextField.text ?? ""
        let noteText = noteTextView.text ?? ""
        let noteDate = Date()
        
        let newNote = Note(context: context)
        newNote.titleNote = titleNote
        newNote.noteText = noteText
        newNote.noteDate = noteDate
        newNote.noteId = UUID().uuidString
        appDelegate.saveContext()
    }
}

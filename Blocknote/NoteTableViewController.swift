//
//  NoteTableViewController.swift
//  Blocknote
//
//  Created by Андрей Сигида on 01/10/2021.
//  Copyright © 2021 Андрей Сигида. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {
    
    private var notes = [Note]()
    private let dateFormatter = DateFormatter()
    private lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        let fetchRequest = Note.fetchRequest() as NSFetchRequest<Note>
        do {
            notes = try context.fetch(fetchRequest)
        } catch let error {
            print("Не удалось загрузить данные из-за ошибки \(error).")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCellIdentifier", for: indexPath)
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.titleNote
        
        if let date = note.noteDate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }
        
        return cell
    }
}

extension NoteTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noteVC = storyboard.instantiateViewController(withIdentifier: "noteViewController") as! AddNoteViewController
        
        let note = notes[indexPath.row]

        noteVC.noteModel = NoteModel(noteTitle: note.titleNote,
                                     noteDescreption: note.noteText,
                                     screenTitle: note.titleNote,
                                     indexNote: indexPath.row,
                                     notes: notes)
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if notes.count > indexPath.row {
                let note = notes[indexPath.row]
                context.delete(note)
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

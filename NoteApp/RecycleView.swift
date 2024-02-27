//
//  RecycleView.swift
//  NoteApp
//
//  Created by Blerta on 2/26/24.
//

import UIKit
import CoreData

class RecycleView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var deletedNotes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.dataSource = self
        tableView.delegate = self
        fetchDeletedNotes()
    }

    func fetchDeletedNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Note>(entityName: "Note")

        // Filter the notes where deletedDate is not nil
        request.predicate = NSPredicate(format: "deletedDate != nil")

        do {
            deletedNotes = try context.fetch(request)
            print("Fetched \(deletedNotes.count) deleted notes") // Debugging statement
            tableView.reloadData() // Reload the table view to display the fetched deleted notes
        } catch {
            print("Fetch failed: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deletedNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = deletedNotes[indexPath.row]
        cell.textLabel?.text = note.titulli
        cell.detailTextLabel?.text = note.pershkrimi
        return cell
    }
}

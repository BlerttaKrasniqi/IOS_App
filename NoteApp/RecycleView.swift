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
    
 
    @IBAction func deleteAllPermanentlyButton(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Delete All Permanently", message: "Are you sure you want to delete all notes permanently?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

            self.performDeleteAllPermanently()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }

    private func performDeleteAllPermanently() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        do {
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.predicate = NSPredicate(format: "deletedDate != nil")
            let notesToDelete = try context.fetch(request)

            for note in notesToDelete {
                context.delete(note)
            }

            try context.save()

            deletedNotes.removeAll()

            tableView.reloadData()

            print("All notes deleted permanently.")
        } catch {
            print("Failed to delete notes permanently: \(error)")
        }
    }
     @IBAction func restoreAllButtonTapped(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Restore All", message: "Are you sure you want to restore all notes?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let restoreAction = UIAlertAction(title: "Restore", style: .default) { _ in
            self.performRestoreAll()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(restoreAction)
        present(alertController, animated: true, completion: nil)
    }
    private func performRestoreAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        do {
            // Fetch all notes with deletedDate not nil
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.predicate = NSPredicate(format: "deletedDate != nil")
            let notesToRestore = try context.fetch(request)

            for note in notesToRestore {
                note.deletedDate = nil
            }

            try context.save()
            deletedNotes.removeAll()

            tableView.reloadData()
            print("All notes restored successfully.")
        } catch {
            print("Failed to restore notes: \(error)")
        }
    }
}

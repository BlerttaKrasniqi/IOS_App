import UIKit
import CoreData

class AddNoteView: UIViewController {
    
    @IBOutlet weak var titulliField: UITextField!
    @IBOutlet weak var pershkrimiTV: UITextView!
    
    var selectednote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectednote != nil){
            titulliField.text = selectednote?.titulli
            pershkrimiTV.text = selectednote?.pershkrimi
        }
    }
       
    @IBAction func ruajButoni(sender: Any){
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appdelegate.persistentContainer.viewContext
        
        if(selectednote == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newnote = Note(entity: entity!, insertInto: context)
            newnote.id = NoteList.count as NSNumber
            newnote.titulli = titulliField.text
            newnote.pershkrimi = pershkrimiTV.text
            
            do{
                try context.save()
                NoteList.append(newnote)
                navigationController?.popViewController(animated: true)
            }
            catch{
                print ("Failed")
            }
        }
        else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do{
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results{
                    let note = result as! Note
                    if(note == selectednote){
                        note.titulli = titulliField.text
                        note.pershkrimi = pershkrimiTV.text
                       try context.save()
                        navigationController?.popViewController(animated: true)
                        
                    }
                }
            }catch{
                print ("Fatch failed")
            }
        }        
    }
    
    @IBAction func fshijbuton(_ sender: Any) {
        
        alertShow()
    }

    func alertShow() {
        
        let alertController = UIAlertController(title: "Delete note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteSelectedNote()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }

    func deleteSelectedNote() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appdelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let note = result as! Note
                if note == selectednote {
                    note.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                    return // Exit loop after deleting note
                }
            }
        } catch {
            print ("Fetch failed")
        }
    }
}


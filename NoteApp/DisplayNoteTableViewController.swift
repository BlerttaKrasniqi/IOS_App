import UIKit
import CoreData

var NoteList = [Note]()

class DisplayNoteTableViewController: UITableViewController {
    var firstload = true
    
    func nonDeletedNotes() -> [Note]{
        var nodeletednote = [Note]()
        for note in NoteList{
            if(note.deletedDate == nil){
                nodeletednote.append(note)
            }
        }
        return nodeletednote
    }
    override func viewDidLoad() {
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "notecellID")
        if(firstload){
            firstload = false
            
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appdelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do{
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results{
                    let note = result as! Note
                    NoteList.append(note)
                }
            }catch{
                print ("Fatch failed")
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notecell = tableView.dequeueReusableCell(withIdentifier: "noteCellId",  for: indexPath) as! TableViewCell
        
        let thisnote: Note!
        thisnote = nonDeletedNotes()[indexPath.row]
        
        notecell.titulliLabel.text = thisnote.titulli
        notecell.pershkrimiLabel.text = thisnote.pershkrimi
        
        return notecell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return nonDeletedNotes().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editNote"){
            let indexPath = tableView.indexPathForSelectedRow!
            let notedetail = segue.destination as? AddNoteView
            let selectednote : Note!
            selectednote = nonDeletedNotes()[indexPath.row]
            notedetail!.selectednote = selectednote
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
}

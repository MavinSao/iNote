//
//  ViewController.swift
//  iNote
//
//  Created by Mavin Sao on 27/9/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var notes: [Note] = []
    var filterNotes: [Note] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var noteCount: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        prepareSearchView()
   
    }
    
    func prepareSearchView() {
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Notes"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
    }
    
    func fetchNotes(){
        self.notes = NoteManager.shared.fetchNote()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewNote" {
            let destinationVC = segue.destination as! NoteViewController
            if isFiltering {
                destinationVC.note = filterNotes[self.tableView.indexPathForSelectedRow!.row]
            }else{
                destinationVC.note = notes[self.tableView.indexPathForSelectedRow!.row]
            }
        }   
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filterNotes = notes.filter { (note: Note) -> Bool in
            guard let title = note.title else {return false}
            return title.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }

    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                let note = filterNotes[indexPath.row]
                filterNotes.remove(at: indexPath.row)
                NoteManager.shared.deleteNote(uid: note.id!)
            }else{
                let note = notes[indexPath.row]
                notes.remove(at: indexPath.row)
                NoteManager.shared.deleteNote(uid: note.id!)
            }
            fetchNotes()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            self.noteCount.title = filterNotes.count > 1 ? "\(filterNotes.count) Notes" : "\(filterNotes.count) Note"
            return filterNotes.count
          }
        self.noteCount.title = notes.count > 1 ? "\(notes.count) Notes" : "\(notes.count) Note"
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.selectionStyle = .none
        
        var note: Note
        
        if isFiltering {
            note = filterNotes[indexPath.row]
         } else {
            note = notes[indexPath.row]
         }
        cell.config(note: note)
        return cell
    }
    

}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
}

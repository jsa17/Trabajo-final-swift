//
//  NotasTableViewController.swift
//  NotyNotes
//
//  Created by Joselin S.A. on 05-10-21.
//
import UIKit
import CoreData


class NotasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    var notas = [Notas()]
    var fetchResultController : NSFetchedResultsController<Notas>!
    var categorias : Categorias!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categorias.nombre
        
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregarNota))
        navigationItem.rightBarButtonItem = buttonAdd
        mostrarNotas()
        

    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let nota = notas[indexPath.row]
        cell.textLabel?.text = nota.titulo
        let formatoFecha = DateFormatter()
        //formatoFecha.dateStyle = .full
        formatoFecha.dateFormat = "dd-MM-yyyy"
        let fecha = formatoFecha.string(from: nota.fecha!)
        cell.detailTextLabel?.text = fecha
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editarNota", sender: self)
    }
    
    override func tableView (_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath ) -> [UITableViewRowAction]?{
        let eliminar = UITableViewRowAction(style: .destructive, title: "Eliminar"){ (_,indexPath)in
            print("Eliminar")
        }
        
        let camara = UITableViewRowAction(style: .normal, title: "Foto"){ (_,indexPath)in
            print("Foto")
        }
        
        return [eliminar, camara]
    }
    
    
    
    //MARK:AGREGAR NOTA
    
    @objc func agregarNota(){
        performSegue(withIdentifier: "agregarNota", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "agregarNota"{
            let destino = segue.destination as!AgregarNotaViewController
            destino.categoria = categorias
            destino.editarGuardar = true
        }
        
        if segue.identifier == "editarNota" {
            if let id = tableView.indexPathForSelectedRow{
                let fila = notas[id.row]
                let destino = segue.destination as!AgregarNotaViewController
                destino.notas = fila
                destino.editarGuardar = false
            }
        }
    }
    
    
    //MARK: FetchedResultsController
    
    func mostrarNotas(){
        let contexto = Conexion().contexto()
        let fetchRequest : NSFetchRequest<Notas> = Notas.fetchRequest()
        let orderByNombre = NSSortDescriptor(key: "titulo", ascending: true)
        fetchRequest.sortDescriptors = [orderByNombre]
        let id_cat = categorias.id
        fetchRequest.predicate = NSPredicate(format: "id_categoria == %@", id_cat! as CVarArg)
        
        fetchResultController = NSFetchedResultsController (fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            notas = fetchResultController.fetchedObjects!
        } catch let error as NSError {
            print("Hubo un error al cargar los datos", error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            self.tableView.reloadData()
        }
        
        self.notas = controller.fetchedObjects as! [Notas]
    }
    
}

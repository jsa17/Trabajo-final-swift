//
//  ViewController.swift
//  NotyNotes
//
//  Created by Joselin S.A. on 05-10-21.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
 
    @IBOutlet weak var tabla: UITableView!
    

    var categorias = [Categorias()]
    var fetcheResultController : NSFetchedResultsController<Categorias>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        mostrarCategorias()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let categoria = categorias[indexPath.row]
        cell.textLabel?.text = categoria.nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "notas", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notas"{
            if let id = tabla.indexPathForSelectedRow {
                let fila  = categorias [id.row]
                let destino = segue.destination as! NotasTableViewController
                destino.categorias = fila
            }
        }
    }
    
    //MARK: Guardar en alerta
    
    
    @IBAction func guardar(_ sender: UIBarButtonItem) {
    
        
        let alerta = UIAlertController(title: "Nueva categoria", message: "Ingresa el nombre para tu nueva categoria", preferredStyle: .alert)
        alerta.addTextField{(nombre) in
            nombre.placeholder = "Nombre de categoria"
        }
        
        let aceptar = UIAlertAction(title: "Aceptar", style: .default){
            (action) in
            guard let nombre = alerta.textFields?.first?.text else{ return}
            let contexto = Conexion().contexto()
            
            let entityCategorias = NSEntityDescription.insertNewObject(forEntityName: "Categorias", into: contexto) as! Categorias
            
            entityCategorias.id = UUID()
            entityCategorias.nombre = nombre
            
            do{
                try contexto.save()
                print("Guardo")
            }catch let error as NSError{
                print("No guardo", error.localizedDescription)
                
            }
            
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alerta.addAction(aceptar)
        alerta.addAction(cancelar)
        present(alerta, animated: true, completion: nil)
        
    
      
    }//fin
    
    
    //MARK: FetchedResultsController
    
    func mostrarCategorias(){
        let contexto = Conexion().contexto()
        let fetchRequest : NSFetchRequest<Categorias> = Categorias.fetchRequest()
        let orderByNombre = NSSortDescriptor(key: "nombre", ascending: true)
        fetchRequest.sortDescriptors = [orderByNombre]
        fetcheResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
    
        fetcheResultController.delegate = self
        
        do {
            try fetcheResultController.performFetch()
            categorias = fetcheResultController.fetchedObjects!
        } catch let error as NSError {
            print("Hubo un error al cargar los datos", error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tabla.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tabla.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tabla.reloadRows(at: [indexPath!], with: .fade)
        default:
            self.tabla.reloadData()
        }
        
        self.categorias = controller.fetchedObjects as! [Categorias]
    }
    
    

}




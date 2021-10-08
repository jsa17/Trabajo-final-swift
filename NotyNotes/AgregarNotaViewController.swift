//
//  AgregarNotaViewController.swift
//  NotyNotes
//
//  Created by Joselin S.A. on 05-10-21.
//

import UIKit
import CoreData

@objc(NoteNotes)
class AgregarNotaViewController: UIViewController {
    
    var categoria : Categorias!
    var notas : Notas!
    
    
    @IBOutlet weak var tituloText: UITextField!
    @IBOutlet weak var textoText: UITextView!
    var editarGuardar : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editarGuardar{
            let buttonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(agregarNota))
            navigationItem.rightBarButtonItem = buttonSave
        }else{
            let buttonEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editarNota))
            navigationItem.rightBarButtonItem = buttonEdit
            tituloText.text = notas.titulo
            textoText.text = notas.texto
        }
       
    }
    
    @objc func agregarNota(){
        let contexto = Conexion().contexto()
        let entityNotas = NSEntityDescription.insertNewObject(forEntityName: "Notas", into: contexto) as! Notas
        
        entityNotas.id = UUID()
        entityNotas.id_categoria = categoria.id
        entityNotas.titulo = tituloText.text
        entityNotas.texto = textoText.text
        entityNotas.fecha = Date()
        
        categoria.mutableSetValue(forKey: "relationToNotas").add(entityNotas)
        
        do {
            try contexto.save()
            print("guardo")
            navigationController?.popViewController(animated: true)
        } catch let error as NSError  {
            print("Hubo un error al cargar la nota", error.localizedDescription)
        }
        
    }
    
    @objc func editarNota(){
        let contexto = Conexion().contexto()
        
        notas.setValue(tituloText.text, forKey: "titulo")
        notas.setValue(textoText.text, forKey: "texto")
        notas.setValue(Date(), forKey: "fecha")
        
        
        
        do {
            try contexto.save()
            print("edito")
            navigationController?.popViewController(animated: true)
        } catch let error as NSError  {
            print("Hubo un error al cargar la nota", error.localizedDescription)
        }
        
    }
    
    

    
}

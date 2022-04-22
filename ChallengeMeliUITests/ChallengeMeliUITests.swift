//
//  ChallengeMeliUITests.swift
//  ChallengeMeliUITests
//
//  Created by Carlos Raymundo Tijerino Capetillo on 21/04/22.
//

import XCTest

class ChallengeMeliUITests: XCTestCase {

    
    //MARK: -
    
    override func setUpWithError() throws {
        continueAfterFailure = false

    }
    
    //MARK: -

    override func tearDownWithError() throws {
    
    }

    
    //MARK: - Search Flow Test
    
    /*Prueba automatizada para verificar que el flujo de la busqueda de un producto se realice de manera correcta*/
    
    func testSearchFlow() throws {
        
        let app = XCUIApplication()
            app.launch()
        
        let searchSearchField = app.navigationBars["Buscar Producto"]/*@START_MENU_TOKEN@*/.searchFields["Search"]/*[[".staticTexts[\"Buscar Producto\"].searchFields[\"Search\"]",".searchFields[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            searchSearchField.tap()
            searchSearchField.typeText("Monitor")
        
        XCUIApplication().tables["Search results"].cells.element(boundBy: 0).tap()
        
        sleep(5)
        
        app.tables.cells.element(boundBy: 0).tap()
               
        sleep(5)
        
        XCTAssertTrue(app.navigationBars["Detalle del producto"].buttons["Buscar Producto"].exists)
        
        app.navigationBars["Detalle del producto"].buttons["Buscar Producto"].tap()
        
    }
    
    //MARK: -
    //ccc
}

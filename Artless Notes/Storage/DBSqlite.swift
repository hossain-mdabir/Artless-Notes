//
//  DBSqlite.swift
//  Plain Notes
//
//  Created by Md Abir Hossain on 30/1/23.
//

import Foundation
import SQLite3


class DBSqlite: ObservableObject {
    
    let dbName: String = "DBSqlite.sqlite"
    var db : OpaquePointer?
    
    // MARK: - Tables
    static let TABLE_TAG = "TabTag"
    static let TABLE_DATA = "TabData"
    
    
    // MARK: - Tag Column
    static let COL_TAG_NAME = "ColTagName"
    
    
    // MARK: - Data Column
    static let COL_TITLE = "ColTitle"
    static let COL_DESCRIPTION = "ColDescription"
    static let COL_ADD_DATE = "ColAddDate"
    static let COL_EDIT_DATE = "ColEditDate"
    
    
//    init(db: OpaquePointer? = nil) {
//        self.db = db
    
    init() {
        
        self.db = createDatabase()
        
//        if !(UserDefaults.standard.bool(forKey: "databaseCreated")) {
            
            self.createTagTable()
            self.createDataTable()
            
//        }
    }
    
    
    func createDatabase() -> OpaquePointer? {
        
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        print("filePath \(filePath)")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error in creating Database")
            return nil
        } else {
            print("Database created : path :- \(dbName)")
            UserDefaults.standard.set(true, forKey: "databaseCreated")
            print("UserDefaults.databaseCreated :: \(UserDefaults.standard.bool(forKey: "databaseCreated"))")
            return db
        }
    }
    
    
    // MARK: - Create Customer Table
    func createTagTable() {
        let query = """
         CREATE TABLE IF NOT EXISTS \(DBSqlite.TABLE_TAG)
         (ID INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBSqlite.COL_TAG_NAME) TEXT
        )
        """
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Tag Table created SUCCESSFULLY")
            } else {
                print("Tag Table creation FAILED")
            }
        } else {
            print("Failed to create Tag Table")
        }
        sqlite3_finalize(statement)
    }
    
    
    // MARK: - Create Customer Table
    func createDataTable() {
        let query = """
         CREATE TABLE IF NOT EXISTS \(DBSqlite.TABLE_DATA)
         (ID INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBSqlite.COL_TAG_NAME) TEXT,
        \(DBSqlite.COL_TITLE) TEXT,
        \(DBSqlite.COL_DESCRIPTION) TEXT,
        \(DBSqlite.COL_ADD_DATE) TEXT,
        \(DBSqlite.COL_EDIT_DATE) TEXT
        )
        """
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data Table created SUCCESSFULLY")
            } else {
                print("Data Table creation FAILED")
            }
        } else {
            print("Failed to create Data Table")
        }
        sqlite3_finalize(statement)
    }
    
    
    // MARK: - Insert Tag in Table
    func insertTag(tag: Tags) {
        
        let query = """
        INSERT INTO  \(DBSqlite.TABLE_TAG) (
        \(DBSqlite.COL_TAG_NAME)
        )
        VALUES (?)
        """
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(statement, 1, ((tag.tagName ?? "") as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Tag Data inserted successfully")
            } else {
                print("Tag Data not inserted in the Table")
            }
        } else {
            print("Tag Query is not as per requirement")
        }
        sqlite3_finalize(statement)
    }
    
    
    
    // MARK: - Insert Tag in Table
    func insertData(data: Datas) {
        
        let query = """
        INSERT INTO  \(DBSqlite.TABLE_DATA) (
        \(DBSqlite.COL_TAG_NAME),
        \(DBSqlite.COL_TITLE),
        \(DBSqlite.COL_DESCRIPTION),
        \(DBSqlite.COL_ADD_DATE),
        \(DBSqlite.COL_EDIT_DATE)
        )
        VALUES (?, ?, ?, ?, ?)
        """
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(statement, 1, ((data.tagName ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, ((data.title ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, ((data.description ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, ((data.addDate ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, ((data.editDate ?? "") as NSString).utf8String, -1, nil)
            
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted successfully")
            } else {
                print("Data not inserted in the Table")
            }
        } else {
            print("Data Query is not as per requirement")
        }
        sqlite3_finalize(statement)
    }
    
    
    
    // MARK: - Get Tag
    func getTag() -> [Tags] {
        
        var mainList = [Tags]()
        var statement: OpaquePointer? = nil
        let query = "SELECT * FROM TabTag"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let tagName = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                
                var tagData = Tags()
                tagData.tagName = tagName
                
                mainList.append(tagData)
                
                print("Tag size -- \(tagData.tagName)")
            }
            
        } else {
            
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n Tag Insert Query is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        print("Tag size : \(mainList.count)")
        
        return mainList
    }
    
    
    // MARK: - Get Data
    func getData(tag: String) -> [Datas] {
        
        var mainList = [Datas]()
        var statement: OpaquePointer? = nil
        let query = "SELECT * FROM TabData WHERE \(DBSqlite.COL_TAG_NAME) = '\(tag)'"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let tagName = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let title = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let description = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let addDate = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                let editDate = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                
                var data = Datas()
                data.tagName = tagName
                data.title = title
                data.description = description
                data.addDate = addDate
                data.editDate = editDate
                
                mainList.append(data)
                
                print("Data size -- \(data.title)")
            }
            
        } else {
            
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n Data Insert Query is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
        
        print("Data size : \(mainList.count)")
        
        return mainList
    }
        
    
    // MARK: - When updating customer information
    func deleteNotes(tag: String, title: String) {
        let query = "DELETE FROM \(DBSqlite.TABLE_DATA) WHERE \(DBSqlite.COL_TAG_NAME) = '\(tag)' AND \(DBSqlite.COL_TITLE) = '\(title)'"
        print("cust update query:: \(query)")
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Single Cust Data delete success")
            }else {
                print("Single Cust Data is not deleted from table")
            }
        }
    }
    
    
    // MARK: - Delete Customer
//    func deleteNotes(tag: String, title: String) {
//        let query = "DELETE FROM \(DBSqlite.TABLE_DATA) WHERE \(DBSqlite.COL_DESCRIPTION) = '\(tag)' AND \(DBSqlite.COL_TITLE) = '\(title)'"
//        var statement : OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
//            if sqlite3_step(statement) == SQLITE_DONE {
//                print("Notes Data delete success")
//            } else {
//                print("Notes Data is not deleted from table")
//            }
//        }
//    }
    
    // MARK: - Delete Customer
    func deleteTag(tagName: Tags) {
        let query = "DELETE FROM \(DBSqlite.TABLE_TAG) WHERE \(DBSqlite.COL_TAG_NAME) = '\(tagName)'"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Tag Data delete success")
            }else {
                print("Tag Data is not deleted from table")
            }
        }
    }
    
    
    // MARK: - Delete Customer
    func deleteTagAllNotes(tagName: String) {
        let query = "DELETE FROM \(DBSqlite.TABLE_DATA) WHERE \(DBSqlite.COL_TAG_NAME) = '\(tagName)'"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("AllNotes Data delete success")
            }else {
                print("AllNotes Data is not deleted from table")
            }
        }
    }
    
    
    // MARK: - Update notes
    func updateNote(datas: Datas, tagName: String, title: String, description: String, editDate: Datas) {
        let query = "UPDATE TabData SET \(DBSqlite.COL_TITLE) = '\(title)', \(DBSqlite.COL_DESCRIPTION) = '\(description)', \(DBSqlite.COL_EDIT_DATE) = '\(dateFormatter(date: Date()))' WHERE \(DBSqlite.COL_TAG_NAME) = '\(datas.tagName ?? "")' AND \(DBSqlite.COL_TITLE) = '\(datas.title ?? "")' AND \(DBSqlite.COL_DESCRIPTION) = '\(datas.description ?? "")'"
        
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Notes Data update success")
            } else {
                print("Notes Data is not updated from table")
            }
        }
    }
    
    
        
}

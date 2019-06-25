//
//  DataManager.swift
//  PingPongResult
//
//  Created by Admin on 24.06.2019.
//  Copyright © 2019 itWorksInUA. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    
    static let manager = DataManager()
    
    private init() {
    }
    
    fileprivate var user: [String: Any] = [:] {
        didSet {
            print("user data \(user.debugDescription)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: .userDataUpdated), object: user)
        }
    }
    
    var userName: String? {
        return user[.userNameKey] as? String
    }
    
    var results: [[String: Any]] {
        return user[.resultsKey] as? [[String: Any]] ?? []
    }
    
    func checkUser(_ completion: (() -> ())?) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection(.usersCollection).getDocuments(completion: { (snapshot, error) in
                if let userData = snapshot?.documents.first(where: { $0.documentID == user.uid })?.data() {
                    self.user = userData
                    completion?()
                }
            })
        }
    }
    
    func addNewRecord(_ record: [String: Any], completion: ((Error?) -> ())?) {
        var data = user
        var results = self.results
        results.append(record)
        data[.resultsKey] = results
        Firestore.firestore().collection(.usersCollection).document(Auth.auth().currentUser!.uid).updateData(data) { (error) in
            if error == nil {
                self.user = data
            }
            completion?(error)
        }
    }
    
    func auth(userName: String, password: String, _ completion: ((Error?) -> ())?) {
        Auth.auth().signIn(withEmail: userName, password: password) { (result, error) in
            self.authCallback(result: result, isSignIn: true, error: error, completion: completion)
        }
    }
    
    func signUp(userName: String, password: String, _ completion: ((Error?) -> ())?) {
        Auth.auth().createUser(withEmail: userName, password: password) { (result, error) in
            self.authCallback(result: result, isSignIn: false, error: error, completion: completion)
        }
    }
    
    fileprivate func authCallback(result: AuthDataResult?, isSignIn: Bool, error: Error?, completion: ((Error?) -> ())?) {
        if let result = result {
            if isSignIn {
                self.checkUser { completion?(nil) }
            } else {
                let data: [String: Any] = [.userNameKey : result.user.email ?? ""]
                self.user = data
                Firestore.firestore().collection(.usersCollection).document(result.user.uid).setData(data, completion: completion)
            }
        } else {
            completion?(error)
        }
    }
}

extension Dictionary where Key == String {
    var value: Int? {
        return self[.valueKey] as? Int
    }
    
    var descr: String? {
        return self[.descrKey] as? String
    }
}

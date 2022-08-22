//
//  SaveData.swift
//  Denemee
//
//  Created by Gürkan Yeşilyurt on 22.08.2022.
//

import Foundation


var favArray = [Int]()

public func AddToFavorites(movieId:Int){
    if(favArray.contains(movieId)){
        return
    }
    print("Item Add,",movieId )

    favArray.append(movieId)
    SaveData()
}

public func InitSaveData(){
    favArray = UserDefaults.standard.object(forKey: "favorites") as? [Int] ?? []

}

public func RemoveFromFavorites(movieId:Int)  {
    print("Item Removed,",movieId )
    favArray = favArray.filter({ $0 != movieId })
    SaveData()
     
}

public func IsExistInFavorites(movieId:Int) -> Bool {
    print(favArray.count)
    if(favArray.contains(movieId)){
        return true
    }
    return false
}


private func SaveData(){
    UserDefaults.standard.set(favArray, forKey: "favorites")
}

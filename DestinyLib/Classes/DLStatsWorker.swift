//
//  StatsWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLStatsWorker {
    
    public static func getDetailStats(_ instanceId: String, group: Int, _ completion: @escaping((_ stats: [DLStatUI]) -> Void )) {
        
        DLStatsWorker.getStatsFor(instanceId) { itemStats, error in
            if itemStats != nil {
                DLStatsWorker.arrangeStats(itemStats!, group: group) { statsUI in
                    completion(statsUI)
                }
            } else {
                completion([])
            }
        }
    }
    
    public static func getStatsFor(_ instanceId: String, _ completion: @escaping((_ stats: [DLItemStat]?, _ error: NSError?) -> Void )) {
        
        DLUserEndpoints.requestInfo(infoType: .itemInstanceStats, itemRequested: instanceId, forPlatform:  DLCurrentSession.shared.userPlatform, userId:  DLCurrentSession.shared.userMembership) { response, error in
            if let statsData = response, let statsDict = statsData["stats"] as? EntityDictionary {
                let statDicts = statsDict.getEntitiesDictionariesFromKeys()
                let stats: [DLItemStat] = DLItemStat.initEntities(dictionaries: statDicts)
                completion(stats, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public static func arrangeStats(_ stats: [DLItemStat], group: Int, _ completion: @escaping((_ stats: [DLStatUI]) -> Void )) {
        
        var statsUI = [DLStatUI]()
        DLManifestWorker.getManifestFor(type: .statGroup, hash: group) { (statGroup: DLStatGroupManifest?, error) in
            if statGroup != nil {
                let dispatchGroup = DispatchGroup()
                stats.forEach { stat in
                    if let numeric = statGroup!.scaledStats.filter({ $0.hash == stat.hash }).first?.displayAsNumeric {
                        dispatchGroup.enter()
                        DLStatsWorker.getStatUI(stat, numeric: numeric) { statUI, error in
                            if statUI != nil {
                                statsUI.append(statUI!)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(statsUI)
                }
            } else {
                completion(statsUI)
            }
        }
    }
    
    public static func getStatUI(_ itemStat: DLItemStat, numeric: Bool, _ completion: @escaping((_ stat: DLStatUI?, _ error: NSError?) -> Void )) {
        
        DLManifestWorker.getManifestDisplayProperties(type: .stat, hash: itemStat.hash) { displayProp, error in
            if displayProp != nil {
                let statUI = DLStatUI(name: displayProp!.name, value: itemStat.value, maxValue: itemStat.maxValue, isNumeric: numeric)
                completion(statUI, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
}

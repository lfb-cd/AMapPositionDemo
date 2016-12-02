//
//  ShowMapViewController+UITableViewDelegate.swift
//  AMapPositionDemo
//
//  Created by lifubing on 16/12/2.
//  Copyright © 2016年 lifubing. All rights reserved.
//

import Foundation

extension ShowMapViewController:UITableViewDataSource,UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 10 {
            return searchDataArray.count
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCellidentify = "tableViewCellID"
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellidentify, for: indexPath) as? tableViewCell
        if tableView.tag == 10 {
            
            if searchDataArray[indexPath.row] is AMapTip {
                let data = searchDataArray[indexPath.row] as? AMapTip
                cell?.titleLabel?.text = data?.name
                cell?.detailLabel?.text = data?.address
            }else if searchDataArray[indexPath.row] is AMapPOI {
                let data = searchDataArray[indexPath.row] as? AMapPOI
                cell?.titleLabel?.text = data?.name
                cell?.detailLabel?.text = data?.address
            }
            
            if indexPath.row == 0 {
                cell?.rightImage.image = UIImage(named: "location_current")
            }else {
                cell?.rightImage.image = nil
            }
            
        }else {
            let data = dataArray[indexPath.row] as? AMapPOI
            cell?.titleLabel?.text = data?.name
            cell?.detailLabel?.text = data?.address
            
            if indexPath.row == 0 {
                cell?.rightImage.image = UIImage(named: "location_current")
            }else {
                cell?.rightImage.image = UIImage(named: "location_other")
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

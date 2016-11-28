//
//  ShowMapViewController.swift
//  AMapPositionDemo
//
//  Created by lifubing on 16/11/25.
//  Copyright © 2016年 lifubing. All rights reserved.
//

import UIKit
import MapKit

class ShowMapViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, MAMapViewDelegate, AMapSearchDelegate,UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var mainViews: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var mapView: MAMapView!
    var dataArray: NSMutableArray!
    var searchDataArray: NSMutableArray!
    
    var currentLocation: CLLocation!
    var search: AMapSearchAPI!
    var city: String!
    
    var didStopLocating:Bool = false
    var _searchResult:UITableView?
    
    var searchResult: UITableView?{
        
        get{
            if _searchResult != nil {
                if !self.mainViews.isDescendant(of: _searchResult!) {
                    self.mainViews.addSubview(_searchResult!)
                }
            }else {
                _searchResult = UITableView.init(frame: self.mainViews.bounds)
                _searchResult?.register(UINib.init(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCellID")
                _searchResult?.delegate = self
                _searchResult?.dataSource = self
                _searchResult?.tag = 10
                
                self.mainViews.addSubview(_searchResult!)
                self.mainViews.bringSubview(toFront: _searchResult!)
            }
            
            return _searchResult
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
//        self.searchBar.barTintColor = UIColor.white
        UISearchBar.appearance().tintColor = UIColor.white
//        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
//        let cancleBtn = self.searchBar.value(forKey: "cancelButton") as! UIButton
//        cancleBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCellID")
        
        dataArray = NSMutableArray()
        searchDataArray = NSMutableArray()
        initMapView()
        initSearch()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = false
        
//        mapView.isShowsUserLocation = true
//        mapView.userTrackingMode = MAUserTrackingMode.follow
//        mapView.pausesLocationUpdatesAutomatically = false
//        //        mapView.allowsBackgroundLocationUpdates = true
        mapView.distanceFilter = 10.0
//        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
    }
    
    
    //MARK:- Initialization - 初始化操作
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.midView.bounds)
        mapView.mapType = .standard
        self.midView.addSubview(mapView)
        mapView.delegate = self
        
        mapView.compassOrigin = CGPoint(x: mapView.compassOrigin.x, y: 22)
        mapView.scaleOrigin = CGPoint(x: mapView.scaleOrigin.x, y: 22)
        mapView.showsCompass = false
        mapView.zoomLevel = 13.1
        
        let but = UIButton.init(type: UIButtonType.custom)
        but.addTarget(self, action: #selector(tapped), for: UIControlEvents.touchUpInside)
        but.frame = CGRect(x: self.midView.bounds.origin.x+10, y: self.midView.bounds.origin.y + self.midView.bounds.size.height - 35, width: 25, height: 25)
        but.setImage(UIImage(named: "gpsStat1"), for: UIControlState.normal)
        
        self.mapView.addSubview(but)
        
        let arraImage = UIImageView(frame: CGRect(origin: CGPoint(x:self.mapView.center.x-20,y:self.mapView.center.y - 20), size: CGSize(width: 28, height: 38)))
        arraImage.center = CGPoint(x: self.mapView.center.x-0.5, y: self.mapView.center.y - arraImage.frame.size.height/2+1)
        arraImage.image = UIImage(named: "arrow")
        self.mapView.addSubview(arraImage)
        
    }
    
    
    func tapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
            self.mapView.compassOrigin = CGPoint(x: self.mapView.compassOrigin.x, y: 22)
            self.mapView.scaleOrigin = CGPoint(x: self.mapView.scaleOrigin.x, y: 22)
            self.mapView.showsCompass = false
            self.mapView.zoomLevel = 13.1
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        })
        
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    func initSearChs() {
        if currentLocation == nil || search == nil {
            return
        }
        
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(currentLocation.coordinate.latitude), longitude: CGFloat(currentLocation.coordinate.longitude))
        
        request.types = "风景名胜|商务住宅|政府机构及社会团体|交通设施服务|道路附属设施|地名地址信息"
        request.sortrule = 0
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
    }
    
    func searchPOI(loca:CLLocation) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(loca.coordinate.latitude), longitude: CGFloat(loca.coordinate.longitude))
        
        request.types = "风景名胜|商务住宅|政府机构及社会团体|交通设施服务|道路附属设施|地名地址信息"
        request.sortrule = 0
        request.requireExtension = true
        search.aMapPOIAroundSearch(request)
    }
    
    // 搜索周围
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.pois.count == 0 {
            return
        }
        dataArray = NSMutableArray.init(array: response.pois)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    // MARK: tableView delegate table代理

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
            
            let data = searchDataArray[indexPath.row] as? AMapTip
            cell?.titleLabel?.text = data?.name
            cell?.detailLabel?.text = data?.address
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
    
    // MARK :mapView 回调
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {

        if currentLocation == nil {
            self.currentLocation = userLocation.location
            initSearChs()
        }
        
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
   
        if view.annotation is MAUserLocation {
            initAction()
        }
    }
    
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        
        if didStopLocating {
            searchPOI(loca: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
        }
        
    }
    
    
    func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        didStopLocating = false
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        didStopLocating = true
    }
    
    func initAction (){
        if ((self.currentLocation) != nil) {
            
            let request = AMapReGeocodeSearchRequest()
            request.location = AMapGeoPoint.location(withLatitude: CGFloat(self.currentLocation.coordinate.latitude
            ), longitude: CGFloat(self.currentLocation.coordinate.longitude))
            
            search.aMapReGoecodeSearch(request)
        }
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        var str = response.regeocode.addressComponent.city;
        if str != nil {
            str = response.regeocode.addressComponent.province
        }
        self.mapView.userLocation.title = str;
        self.mapView.userLocation.subtitle = response.regeocode.formattedAddress
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK :搜索的回调
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
        if response.count == 0 {
            return
        }
        self.searchDataArray = NSMutableArray.init(array: response.tips)
        self.searchResult?.reloadData()
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let tips = AMapInputTipsSearchRequest()
        tips.keywords = searchBar.text;
        tips.city     = "北京";
        //    tips.cityLimit = YES; 是否限制城市
        self.search.aMapInputTipsSearch(tips);
        print(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false

        searchBar.resignFirstResponder()
        searchBar.text = ""
        if _searchResult == nil {
            return
        }
        self.searchResult?.removeFromSuperview()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    @IBAction func back(_ sender: Any) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            searchBar.showsCancelButton = false
        }else {

        }
    }

    // MARK :scrollView delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.showsCancelButton = false
        
        searchBar.resignFirstResponder()
    }
}

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}
class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var selectedPin: MKPlacemark? = nil
    var selectedAnnotation: MKAnnotation? = nil
    var resultSearchController: UISearchController? = nil
    
    // Gives access to the location manager throughout the scope of the controller
    var locationManager = CLLocationManager()
    var hasMadeInitialSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User location
        // Delegate handles reponses asynchronously for quicker response time
        locationManager.delegate = self
        // Gives best accuracy on location while saving battery life
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // Triggers location permission dialog
        locationManager.requestWhenInUseAuthorization()
        // Triggers one time location reqeust
        locationManager.requestLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        self.title = "Good Food"
        
    }
    
    // MARK: - Directions function
    // Directions in Apple Maps
    // Use API that launches the Apple Maps app with driving directions
    func getDirections() {
        
        guard let selectedPin = self.selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        mapItem.name = (self.selectedAnnotation?.title)!
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
    
    
}
extension MapViewController : CLLocationManagerDelegate {
    
    // Gets called when user reponds to the permission dialog
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    // Gets called when location info comes back as array of items. Capture the first one. Zoom into this location, combining coordinate and span into region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        if locations.count == 1, hasMadeInitialSearch == false {
            hasMadeInitialSearch = true
            self.initialSearchWith(locationCoordinate: location.coordinate)}
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func initialSearchWith(locationCoordinate: CLLocationCoordinate2D) {
        
        //        let request = MKLocalSearchRequest()
        // change search region here:
        let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let searchTerms: [String] = ["farmers market", "cold press juice", "organic juice"]
        let group = DispatchGroup()
        
        for searchTerm in searchTerms {
            group.enter()
            
            let request = MKLocalSearchRequest()
            
            request.naturalLanguageQuery = searchTerm
            request.region = region
            let search = MKLocalSearch(request: request)
            // executes query and returns a MKLocalSearchResponse object which contains an array of mapItems that are then stashed into placeholder
            search.start { response, _ in
                guard let response = response else {
                    group.leave()
                    return
                }
                
                for item in response.mapItems {
                    
                    var found: Bool = false
                    
                    let placemark = item.placemark
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = placemark.coordinate
                    annotation.title = placemark.name
                    
                    if let city = placemark.locality,
                        let state = placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                        item.name = city
                        
                    }
                    
                    for pin in self.mapView.annotations {
                        guard let annotationTitle = annotation.title, let pinTitle = pin.title else { return }
                        if pinTitle == annotationTitle {
                            found = true
                        }
                    }
                    
                    if found == false {
                        self.mapView.addAnnotation(annotation)
                    }
                    
                    
                    
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("Finished")
        }
        
    }
}
extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}
extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let annotation = annotation
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        // Set pin design here:
        pinView?.pinTintColor = UIColor.red
        pinView?.canShowCallout = true
        pinView?.animatesDrop = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "L1"), for: UIControlState())
        
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        self.selectedPin = placemark
        self.selectedAnnotation = annotation
    }
}

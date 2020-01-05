//
//  MKMapView.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/4/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint.init(annotation.coordinate)
            let pointRect       = MKMapRect.init(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets.init(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        
        var zoomRect:MKMapRect  = MKMapRect.null
        
        for annotation in annotations {
            let aPoint          = MKMapPoint.init(annotation.coordinate)
            let rect            = MKMapRect.init(x: aPoint.x, y: aPoint.y, width: 0.071, height: 0.071)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
}

//
//  PlacesArtowrkView.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/7/20.
//

import MapKit

class PlacesArtowrkView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let artwork = newValue as? Place else{
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24)))
            mapsButton.tintColor = .black
            mapsButton.setBackgroundImage(UIImage(systemName: "arrow.right"), for: .normal)
            rightCalloutAccessoryView = mapsButton

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel

            markerTintColor = artwork.markerTintColor
            if let letter = artwork.title?.first{
                glyphText = String(letter)
            }
        }
    }
}

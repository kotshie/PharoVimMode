"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestPharoVimMode,
	#superclass : #PackageManifest,
	#category : #'PharoVimMode-Manifest'
}

{ #category : #'code-critics' }
ManifestPharoVimMode class >> ruleBadMessageRule2V1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#PharoVimMode)) #'2021-05-12T14:35:45.910129-07:00') )
]

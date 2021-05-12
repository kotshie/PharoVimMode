Class {
	#name : #BaselineOfPharoVimMode,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoVimMode
}

{ #category : #baselines }
BaselineOfPharoVimMode >> baseline: spec [
	<baseline>
	spec 
		for: #common
		do: [ spec package: 'PharoVimMode' ]
		
]

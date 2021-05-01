Class {
	#name : #StVimEnableCommand,
	#superclass : #StCommand,
	#category : #PharoVimMode
}

{ #category : #default }
StVimEnableCommand class >> defaultDescription [

	^ 'Enable/Disable VIM Mode'
]

{ #category : #default }
StVimEnableCommand class >> defaultName [

	^ 'Enable VIM Mode'
]

{ #category : #default }
StVimEnableCommand class >> hideVimModeLabel [ 
	^ 'Disable VIM Mode'
]

{ #category : #default }
StVimEnableCommand class >> iconLabelFor: aBoolean [
	
	^ aBoolean 
		ifTrue: [ '+V' ]
		ifFalse: [ 'V' ]
]

{ #category : #default }
StVimEnableCommand class >> showVimModeLabel [  
	^ 'Enable VIM Mode'
]

{ #category : #executing }
StVimEnableCommand >> execute [ 
	context enableVimMode
]

{ #category : #executing }
StVimEnableCommand >> name [ 
	^ context enableVimMode 
		ifTrue: [ self class hideVimModeLabel ]
		ifFalse: [ self class showVimModeLabel ]
]

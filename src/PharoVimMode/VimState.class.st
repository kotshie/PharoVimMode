Class {
	#name : #VimState,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'agent',
		'toggleVimModeButton'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #PharoVimMode
}

{ #category : #accessing }
VimState class >> new [
    self error: 'Vim is a singleton -- send uniqueInstance instead'
]

{ #category : #accessing }
VimState class >> uniqueInstance [
	^uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : #accessing }
VimState >> agent [

	^ agent
]

{ #category : #accessing }
VimState >> agent: anObject [

	agent := anObject
]

{ #category : #accessing }
VimState >> enabled [

	^ enabled
]

{ #category : #accessing }
VimState >> enabled: anObject [

	enabled := anObject
]

{ #category : #initialization }
VimState >> initialize [ 
	enabled := false.
	agent := VimAgent new mode: VimAbstractMode normalMode.
]

{ #category : #accessing }
VimState >> toggleVimModeButton [

	^ toggleVimModeButton
]

{ #category : #initialization }
VimState >> toggleVimModeButton: aStatusBar [
	toggleVimModeButton := aStatusBar newToggleButton
]

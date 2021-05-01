Class {
	#name : #VimAgent,
	#superclass : #Object,
	#instVars : [
		'mode'
	],
	#category : #PharoVimMode
}

{ #category : #'as yet unclassified' }
VimAgent >> getMode: aKeyboardEvent [
	mode isNil | (aKeyboardEvent keyCharacter = Character escape)
		ifTrue: [ ^ VimAbstractMode normalMode  ]
		ifFalse: [ ^mode ].
]

{ #category : #'as yet unclassified' }
VimAgent >> handleInput: aKeyboardEvent for: anEditor [ 
	| handled |
	mode := self getMode: aKeyboardEvent.
	handled := (mode isKindOf: VimInsertMode) not.
	"mode := mode handleInput: aKeyboardEvent for: anEditor."
	Transcript show: aKeyboardEvent; cr.
	^false
]

{ #category : #testing }
VimAgent >> isInsertMode [
 ^ mode isKindOf: VimInsertMode
]

{ #category : #testing }
VimAgent >> isNormalMode [
 ^ mode isKindOf: VimNormalMode
]

{ #category : #accessing }
VimAgent >> mode [

	^ mode
]

{ #category : #accessing }
VimAgent >> mode: anObject [

	mode := anObject
]

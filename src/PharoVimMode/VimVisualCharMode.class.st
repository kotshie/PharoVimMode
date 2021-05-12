Class {
	#name : #VimVisualCharMode,
	#superclass : #VimAbstractMode,
	#category : #PharoVimMode
}

{ #category : #initialization }
VimVisualCharMode >> initialize [ 
	keymap := VimVisualCharModeKeymap new.
	keys := ''.
]

{ #category : #initialization }
VimVisualCharMode >> undo: aKeyboardEvent [
	"u"
	editor editor selectAt: markIndex.
	^self normalMode.
]

{ #category : #initialization }
VimVisualCharMode >> visualCharMode: anEditor [
	| mode |
	mode := self class visualCharMode.
	mode markIndex: editor editor pointIndex.
	mode markStartIndex: markIndex.
	mode markStopIndex: markIndex.
	editor editor selectFrom: markIndex to: markIndex.
	^ mode
]

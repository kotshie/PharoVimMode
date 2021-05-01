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

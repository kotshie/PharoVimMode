Class {
	#name : #VimVisualLineMode,
	#superclass : #VimAbstractMode,
	#category : #PharoVimMode
}

{ #category : #initialization }
VimVisualLineMode >> initialize [
 keymap := VimVisualLineModeKeymap new.
 keys := ''.
]

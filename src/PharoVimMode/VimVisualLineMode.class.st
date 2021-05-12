Class {
	#name : #VimVisualLineMode,
	#superclass : #VimAbstractMode,
	#category : #PharoVimMode
}

{ #category : #copying }
VimVisualLineMode >> copySelectedLines: aKeyboardEvent [
	| text rubEditor |
	rubEditor := editor editor.
	text := rubEditor selection , String cr.
	rubEditor clipboardTextPut: text.
	rubEditor selectAt: markStartIndex.
	^ self normalMode
]

{ #category : #initialization }
VimVisualLineMode >> initialize [
 keymap := VimVisualLineModeKeymap new.
 keys := ''.
]

{ #category : #copying }
VimVisualLineMode >> undo: aKeyboardEvent [
	"u"
	editor editor selectAt: markIndex.
	^self normalMode
]

Class {
	#name : #VimNormalFindAfterPreviousModeKeymap,
	#superclass : #VimKeymap,
	#category : #'PharoVimMode-Vim'
}

{ #category : #accessing }
VimNormalFindAfterPreviousModeKeymap >> keymap [
	| cmdMap assocs |
	cmdMap := Dictionary new.
		0 to: 255 do: [ :i |
		   cmdMap at: (Character value: i) put: #findAfterPreviousCharacter: ].
	assocs := {
	}.
	assocs do: [ :x | cmdMap at: x key put: x value ].
	^ cmdMap
]

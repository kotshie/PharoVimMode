Class {
	#name : #VimInsertMode,
	#superclass : #VimAbstractMode,
	#category : #'PharoVimMode-Vim'
}

{ #category : #'as yet unclassified' }
VimInsertMode >> handleInput: aKeyboardEvent for: anEditor [
	editor := anEditor.
	aKeyboardEvent commandKeyPressed & (aKeyboardEvent keyCharacter = $a)
		ifTrue: [ editor selectAll: aKeyboardEvent ].
	^self
]

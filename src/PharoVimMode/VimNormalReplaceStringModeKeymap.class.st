Class {
	#name : #VimNormalReplaceStringModeKeymap,
	#superclass : #VimKeymap,
	#category : #'PharoVimMode-Vim'
}

{ #category : #accessing }
VimNormalReplaceStringModeKeymap >> keymap [ 
	| cmdMap assocs |
	cmdMap := Dictionary new.
	0 to: 255 do: [ :i | cmdMap at: (Character value: i) put: #replaceString: ].
	assocs := { }.
	assocs do: [ :x | cmdMap at: x key put: x value ].
	^cmdMap
]

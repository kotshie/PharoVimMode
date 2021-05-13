Class {
	#name : #VimNormalChangeModeMap,
	#superclass : #VimKeymap,
	#category : #PharoVimMode
}

{ #category : #accessing }
VimNormalChangeModeMap >> keymap [
	| cmdMap assocs |
	cmdMap := Dictionary new.
	0 to: 255 do: [ :i | cmdMap at: (Character value: i) put: #noop:  ].
	assocs := {
		($w -> #deleteWordAndInsert:).
	}.
	assocs do: [ :x | cmdMap at: x key put: x value ].
	^cmdMap
	
]

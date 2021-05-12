Class {
	#name : #VimNormalMode,
	#superclass : #VimAbstractMode,
	#category : #PharoVimMode
}

{ #category : #'as yet unclassified' }
VimNormalMode >> handleInput: aKeyboardEvent for: anEditor [
	| key newKeymap action newMode performAction |
	editor := anEditor.
	key := aKeyboardEvent keyCharacter.
	
	(keymap isKindOf: VimNormalDefaultModeKeymap) & (aKeyboardEvent keyCharacter isDigit)
		ifTrue: [ key = $0 & (times = '') ifFalse: [ times := (times, key asString). ^self ] ].
	
	newKeymap := (self updateKeymap: aKeyboardEvent ).
	
	(keymap isKindOf: VimNormalDefaultModeKeymap) & ((newKeymap isKindOf: VimNormalDefaultModeKeymap ) not)
		ifTrue: [ 
			Transcript show: newKeymap asString; cr.
			keymap := newKeymap.
			^ self
		].
	keymap := newKeymap.
	action := (keymap keymap) at: key ifAbsent: [ #noop: ].
	Transcript show: key asciiValue; cr.
	
	action == #noop:
		ifTrue: [ keys := ''. ].
	

	performAction := [ 
		newMode := (action asString endsWithAColon )
			ifTrue: [ self perform: action with: aKeyboardEvent ]
			ifFalse: [ self perform: action ].].
	times = ''  ifTrue: [ 
		times := '1'. 
		performAction value.
		^ newMode
	].
	1 to: (times asInteger) do: [ :x | performAction value ].
	^ newMode
		
	
	
	
	
]

{ #category : #initialization }
VimNormalMode >> initialize [ 
	keymap := VimNormalDefaultModeKeymap new.
	keys := ''.
	times := ''.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> insertBeforeCursor: aKeyboardEvent [
	^ self insertMode
]

{ #category : #'as yet unclassified' }
VimNormalMode >> updateKeymap: aKeyboardEvent [
	| assocs cmdMap |
	
	(keymap isKindOf: VimNormalDefaultModeKeymap ) ifFalse: [ ^ keymap ].
	
	cmdMap := Dictionary new.
	assocs := { 
		($d -> VimNormalDeleteModeKeymap new).
		($r -> VimNormalReplaceCharacterKeymap new).
		($R -> VimNormalReplaceStringModeKeymap new).
		($y -> VimNormalCopyModeKeymap new).
		($g -> VimNormalGoToModeKeymap new).
		($f -> VimNormalFindNextModeKeymap new).
		($t -> VimNormalFindBeforeNextModeKeymap new).
		($F -> VimNormalFindPreviousModeKeymap new).
		($T -> VimNormalFindAfterPreviousModeKeymap new).
	}.
	assocs do: [ :assoc | cmdMap at: assoc key put: assoc value ].
	^cmdMap at: aKeyboardEvent keyCharacter ifAbsent: [ ^VimNormalDefaultModeKeymap new ].
]

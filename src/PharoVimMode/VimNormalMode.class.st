Class {
	#name : #VimNormalMode,
	#superclass : #VimAbstractMode,
	#category : #PharoVimMode
}

{ #category : #accessing }
VimNormalMode >> cursorBackwardWordBegin: aKeyboardEvent [
	| str rubEditor index |
	self haltOnce.
	rubEditor := editor editor.
	str := rubEditor string.
	index := rubEditor pointIndex.

	index = (str size + 1 & index) = 1 ifTrue: [ ^ self normalMode ].

	index := index min: str size.

	index > 1 ifTrue: [ 
		(str at: index) isAlphaNumeric ifTrue: [ index := index - 1 ] ].

	[ 
	index > 1
		ifTrue: [ (str at: index) isAlphaNumeric not ]
		ifFalse: [ false ] ] whileTrue: [ index := index - 1 ].

	index = 1 ifTrue: [ 
		rubEditor selectAt: index.
		^ self normalMode ].

	[ index > 1
		ifTrue: [ (str at: index) isAlphaNumeric ]
		ifFalse: [ false ] ] whileTrue: [ index := index - 1 ].
	
	rubEditor selectAt: index + 1.
	^self normalMode
	
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorDown: aKeyboardEvent [
	editor editor cursorDown: aKeyboardEvent.
	^ self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorLeft: aKeyboardEvent [
	editor editor cursorLeft: aKeyboardEvent.
	^ self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorLineEnd: aKeyboardEvent [
	"$"
	| index |
	index := self indexOfEndOfCurrentLine.
	editor editor selectAt: index.
	^ self normalMode

]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorRight: aKeyboardEvent [
	editor editor cursorRight: aKeyboardEvent.
	^ self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorUp: aKeyboardEvent [
	editor editor cursorUp: aKeyboardEvent.
	^ self normalMode.
]

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

{ #category : #'as yet unclassified' }
VimNormalMode >> indexOfEndOfCurrentLine [
	| pointIndex index |
	pointIndex := editor editor pointIndex.
	index := pointIndex = (editor string size + 1)
		ifTrue: [ pointIndex ]
		ifFalse: [  self indexOfEndOfCurrentLine_ ].
	^ index
]

{ #category : #'as yet unclassified' }
VimNormalMode >> indexOfEndOfCurrentLine_ [
	| count lines sizes lineSize rubEditor |
	rubEditor := editor editor.
	count  := rubEditor string lineNumberCorrespondingToIndex: rubEditor pointIndex.
	lines := rubEditor string lines first: count.
	lineSize :=  [ :xs | xs size + 1 ].
	sizes := lines collect: lineSize.
	^ sizes sum
	
]

{ #category : #initialization }
VimNormalMode >> initialize [ 
	keymap := VimNormalDefaultModeKeymap new.
	keys := ''.
	times := ''.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> insertAtEndOfLine: aKeyboardEvent [
	self cursorLineEnd: aKeyboardEvent.
	^ self insertMode
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

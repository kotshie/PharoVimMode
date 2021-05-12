Class {
	#name : #VimNormalMode,
	#superclass : #VimAbstractMode,
	#category : #PharoVimMode
}

{ #category : #accessing }
VimNormalMode >> cursorBackwardWordBegin: aKeyboardEvent [
	| str rubEditor index |
	" TODO: Fix this "
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

{ #category : #accessing }
VimNormalMode >> cursorLineBegin: aKeyboardEvent [
	editor editor cursorHome: aKeyboardEvent.
	^ self normalMode
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

{ #category : #accessing }
VimNormalMode >> cursorWordBegin: aKeyboardEvent [
	| str index rubEditor |
	rubEditor := editor editor.
	str := rubEditor string.
	index := rubEditor pointIndex.
	
 	[ (index <= (str size)) and: [ (str at: index) isAlphaNumeric  ] ]
		whileTrue: [ index := index + 1 ].
	
	[ (index <= (str size)) and: [ (str at: index) isAlphaNumeric not ] ]
		whileFalse: [ index := index + 1 ].
	
	rubEditor selectAt: index.
	^self normalMode
]

{ #category : #'as yet unclassified' }
VimNormalMode >> deleteLine: aKeyboardEvent [
	| start end position rubEditor |
	" dd "
	rubEditor := editor editor.
	position := rubEditor pointIndex.
	rubEditor cursorHome: aKeyboardEvent.
	start := rubEditor pointIndex.
	rubEditor cursorEnd: aKeyboardEvent.
	end := rubEditor pointIndex.
	rubEditor selectFrom: start to: end.
	rubEditor cut.
	
	(start = end) & (end > (rubEditor string size))
		ifTrue: [  
			rubEditor backspace: aKeyboardEvent.
			rubEditor clipboardTextPut: String cr.
			^ self normalMode
		].
	
	start = end 
		ifTrue: [ rubEditor clipboardTextPut: '' ]
		ifFalse: [ rubEditor clipboardTextPut: (String cr, rubEditor clipboardText) ].
		
	^self normalMode
	
	
	
]

{ #category : #'as yet unclassified' }
VimNormalMode >> enableVisualCharMode: aKeyboardEvent [
	| mode index rubEditor |
	rubEditor := editor editor.
	mode := self class visualCharMode: editor.
	index := rubEditor pointIndex.
	rubEditor selectFrom: index to: index.
	^mode
]

{ #category : #'as yet unclassified' }
VimNormalMode >> enableVisualLineMode: aKeyboardEvent [
	| mode rubEditor |
	rubEditor := editor editor.
	mode := self class visualLineMode: editor.
	mode markIndex: rubEditor startIndex.
	mode markStartIndex: rubEditor startIndex.
	mode markStopIndex: rubEditor stopIndex.
	^mode
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
VimNormalMode >> redoChanges: aKeyboardEvent [
	aKeyboardEvent controlKeyPressed 
		ifTrue: [ editor editor redo ].
	^ self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> replaceCharacter: aKeyboardEvent [
	"r"
	| str position rubEditor |
	rubEditor := editor editor.
	position := rubEditor pointIndex.
	str := (Character value: (aKeyboardEvent keyValue)) asString.
	rubEditor selectFrom: position to: position.
	rubEditor replaceSelectionWith: str.
	rubEditor selectAt: position.
	^self normalMode
]

{ #category : #'as yet unclassified' }
VimNormalMode >> replaceString: aKeyboardEvent [
	"r"
	| str position rubEditor |
	rubEditor := editor editor.
	position := rubEditor pointIndex.
	str := (Character value: (aKeyboardEvent keyValue)) asString.
	rubEditor selectFrom: position to: position.
	rubEditor replaceSelectionWith: str.
	rubEditor selectAt: position + 1.
	^self
]

{ #category : #'as yet unclassified' }
VimNormalMode >> undo [
	editor editor undo.
	^ self normalMode
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

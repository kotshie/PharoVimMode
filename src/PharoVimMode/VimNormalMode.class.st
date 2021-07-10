Class {
	#name : #VimNormalMode,
	#superclass : #VimAbstractMode,
	#category : #'PharoVimMode-Vim'
}

{ #category : #'as yet unclassified' }
VimNormalMode >> appendNewLine: aKeyboardEvent [
	| rubEditor |
	"o"
	rubEditor := editor editor.
	rubEditor cursorEnd: aKeyboardEvent.
	rubEditor insertAndSelect: String cr at: rubEditor pointIndex.
	rubEditor cursorRight: aKeyboardEvent.
	^self insertMode
	
	
]

{ #category : #'as yet unclassified' }
VimNormalMode >> copyLine: aKeyboardEvent [
	"yy" 
	| position text lineIndex rubEditor |
	rubEditor := editor editor.
	position := rubEditor pointIndex.
	lineIndex := rubEditor string lineNumberCorrespondingToIndex: position.
	text := (lineIndex <= rubEditor string lines size)
		ifTrue: [ rubEditor string lines at: lineIndex ]
		ifFalse: [ '' ].
	
	text := String cr, text.
	rubEditor clipboardTextPut: text.
	
	^self normalMode

]

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
VimNormalMode >> cursorBufferBegin: aKeyboardEvent [
	self editor editor selectAt: 1.
	^self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorDown: aKeyboardEvent [
	editor editor cursorDown: aKeyboardEvent.
	editor textArea scrollSelectionIntoView: aKeyboardEvent.
	^ self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorLeft: aKeyboardEvent [
	editor editor cursorLeft: aKeyboardEvent.
	editor textArea scrollSelectionIntoView: aKeyboardEvent.
	^ self normalMode.
]

{ #category : #accessing }
VimNormalMode >> cursorLineBegin: aKeyboardEvent [
	editor editor cursorHome: aKeyboardEvent.
	^ self normalMode
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorLineBeginNoneEmpty: aKeyboardEvent [
	"^"
	| str index rubEditor |
	self cursorLineBegin: aKeyboardEvent.
	rubEditor := editor editor.
	index := rubEditor pointIndex.
	str := rubEditor string.
	
	[ index < (str size)
		ifTrue: [ (str at: index) isAlphaNumeric not ]
		ifFalse: [ false ] ] whileTrue: [ index := index + 1 ].
	
	rubEditor selectAt: index.
	^self normalMode.

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
VimNormalMode >> cursorLineEndNoneEmpty: aKeyboardEvent [
	| rubEditor str index |
	"g_"
	self cursorLineEnd: aKeyboardEvent.
	rubEditor := editor editor.
	str := rubEditor string.
	index := (rubEditor pointIndex) - 1.
	
	[(index > 1) 
		ifTrue: [ (str at: index) isSpaceSeparator ]
		ifFalse: [ false ]] whileTrue: [ index := index - 1 ].
	
	rubEditor selectAt: index .
	^ self normalMode

]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorRight: aKeyboardEvent [
	editor editor cursorRight: aKeyboardEvent.
	editor textArea scrollSelectionIntoView: aKeyboardEvent.
	^ self normalMode.
]

{ #category : #'as yet unclassified' }
VimNormalMode >> cursorUp: aKeyboardEvent [
	editor editor cursorUp: aKeyboardEvent.
	editor textArea scrollSelectionIntoView: aKeyboardEvent.
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
		whileTrue: [ index := index + 1 ].
	
	rubEditor selectAt: index.
	^self normalMode
]

{ #category : #accessing }
VimNormalMode >> cursorWordEnd: aKeyboardEvent [
	| str index rubEditor initialIsAlphaNumberic |
	
	rubEditor := editor editor.
	index := rubEditor pointIndex.
	str := rubEditor string.
	index = ((str size) + 1)
		ifTrue: [ ^self normalMode ].

	initialIsAlphaNumberic := (str at: index) isAlphaNumeric.
	initialIsAlphaNumberic 
		ifTrue: [ 
			[ index <= str size and: [ (str at: index) isAlphaNumeric  ] ] 
				whileTrue: [ index := index + 1 ].
			rubEditor selectAt: index. 
			^ self normalMode
		].


	[  index <= str size and: [ (str at: index) isAlphaNumeric not ] ] whileTrue: [ index := index + 1 ].
	[  index <= str size and: [ (str at: index) isAlphaNumeric ] ] whileTrue: [ index := index + 1 ].

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
		ifFalse: [ rubEditor clipboardTextPut: rubEditor clipboardText ].
		
	^self normalMode
	
	
	
]

{ #category : #'as yet unclassified' }
VimNormalMode >> deleteLineEnd: aKeyboardEvent [
	| start end rubEditor |
	rubEditor := editor editor.
	start := rubEditor pointIndex.
	self cursorLineEnd: aKeyboardEvent.
	end := (rubEditor pointIndex) > start
		ifTrue: [ (rubEditor pointIndex) - 1]
		ifFalse: [ rubEditor pointIndex ].
	rubEditor selectFrom: start to: end.
	rubEditor cut.
	^ self normalMode

]

{ #category : #'as yet unclassified' }
VimNormalMode >> deleteWord: aKeyboardEvent [
	| start end rubEditor |
	rubEditor := editor editor.
	start := rubEditor pointIndex.
	self cursorWordEnd: aKeyboardEvent.
	end := (rubEditor pointIndex) > start
		ifTrue: [ (editor pointIndex) - 1]
		ifFalse: [ editor pointIndex ].
	rubEditor selectFrom: start to: end.
	rubEditor cut.
	^self normalMode.
	
]

{ #category : #'as yet unclassified' }
VimNormalMode >> deleteWordAndInsert: aKeyboardEvent [
	self deleteWord: aKeyboardEvent.
	^self insertMode.
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
VimNormalMode >> forwardDelete: aKeyboardEvent [
	editor editor forwardDelete: aKeyboardEvent 
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
			keymap := newKeymap.
			^ self
		].
	keymap := newKeymap.
	action := (keymap keymap) at: key ifAbsent: [ #noop: ].
	
	action == #noop:
		ifTrue: [ keys := ''. ].
	
	performAction := [ 
		newMode := (action asString endsWithAColon )
			ifTrue: [ self perform: action with: aKeyboardEvent ]
			ifFalse: [ self perform: action ].
	].

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
VimNormalMode >> insertAtBeginOfLine: aKeyboardEvent [
	self cursorLineBegin: aKeyboardEvent.
	^ self insertMode
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
VimNormalMode >> pasteText: aKeyboardEvent [
	| text pasteLines paste pasteCR rubEditor |
	rubEditor := editor editor.
	text := rubEditor clipboardText.
	pasteCR := [ 
		self cursorLineEnd: aKeyboardEvent. 
		rubEditor paste.
		^ self normalMode
	].

	pasteLines := [  
		rubEditor paste.	
		self cursorLineBegin: aKeyboardEvent.
	].

	paste := [ rubEditor paste ].
	
	" empty "
	text isEmpty ifTrue: [ ^self normalMode ].
	
	" cr "
	text = String cr ifTrue: pasteCR.
	
	" lines / other "
	text first = Character cr 
		ifTrue: pasteLines 
		ifFalse: paste.
		
	^self normalMode.
	
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
	   ($c -> VimNormalChangeModeMap new).
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

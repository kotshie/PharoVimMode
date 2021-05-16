Class {
	#name : #VimVisualCharMode,
	#superclass : #VimAbstractMode,
	#category : #'PharoVimMode-Vim'
}

{ #category : #initialization }
VimVisualCharMode >> alphanums [
	^ Character allCharacters select: [ :x | x isAlphaNumeric ]
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeBackwardWORDBegin: aKeyboardEvent [
	| begin end | 
	begin := editor editor startIndex.
	end   := self cursorBackwardWORDBeginIndex: aKeyboardEvent.
	editor editor selectFrom: begin to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeBackwardWordBegin: aKeyboardEvent [
	| begin end | 
 	begin := editor editor startIndex.
	end   := self cursorBackwardWordBeginIndex: aKeyboardEvent.
	editor editor selectFrom: begin to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeDown: aKeyboardEvent [ 
	| rubEditor |
	"j"
	rubEditor := editor editor.
	((rubEditor string lineNumberCorrespondingToIndex: markIndex ) >= (rubEditor string lineNumberCorrespondingToIndex: rubEditor stopIndex))
	  ifTrue: [ self charModeDownBelow: aKeyboardEvent ] 
	  ifFalse: [ self charModeDownAbove: aKeyboardEvent ].
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeDownAbove: aKeyboardEvent [
 "j"
	| start end |
	start   := self charModeDownAboveStartIndex.
	end     := markIndex.
	editor editor selectFrom: start to: end.
	^ true
]

{ #category : #initialization }
VimVisualCharMode >> charModeDownAboveStartIndex [ 
	| length index distance currentLineIndex previousLineIndex line offset rubEditor |

	rubEditor := editor editor.	
	currentLineIndex := rubEditor string lineNumberCorrespondingToIndex: rubEditor startIndex.
	currentLineIndex = rubEditor string lines size 
	 ifTrue: [ ^ rubEditor startIndex ].
	
	previousLineIndex := currentLineIndex + 1.
	
	line := editor string lineNumber: previousLineIndex. 
	distance := self lengthBetweenLastCrAndStopIndex.
	offset := line size min: distance.
	offset := offset + 1. 
	length := [ ((((rubEditor string lines) first: currentLineIndex )) collect: [ :x | 1 + x size] ) sum ].
	index := 	length value + offset.
	^ index.
]

{ #category : #initialization }
VimVisualCharMode >> charModeDownBelow: aKeyboardEvent [
	"j"
	| start end |
	start := markIndex.
	end   := self charModeDownBelowStopIndex.
	editor editor selectFrom: start to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeDownBelowStopIndex [

	| len currentEndOfLineIndex end distance nextEndOfLineIndex rubEditor |
	rubEditor := editor editor.
	currentEndOfLineIndex := self endOfLineIndex: rubEditor stopIndex.
	nextEndOfLineIndex := currentEndOfLineIndex
	                      ~= (rubEditor string size + 1)
		                      ifTrue: [ 
		                      self endOfLineIndex: currentEndOfLineIndex + 1 ]
		                      ifFalse: [ currentEndOfLineIndex ].

	currentEndOfLineIndex = nextEndOfLineIndex
		ifTrue: [ end := rubEditor stopIndex - 1 ]
		ifFalse: [ 
			distance := self lengthBetweenLastCrAndStopIndex.
			len := distance min: nextEndOfLineIndex - currentEndOfLineIndex - 1.
			end := currentEndOfLineIndex + len ].

	^ end
]

{ #category : #initialization }
VimVisualCharMode >> charModeLeft: aKeyboardEvent [
 "h" 
 self isAbove 
  ifTrue: [ ^ self charModeLeftAbove: aKeyboardEvent ]
  ifFalse: [ ^ self charModeLeftBelow: aKeyboardEvent ].
]

{ #category : #initialization }
VimVisualCharMode >> charModeLeftAbove: aKeyboardEvent [
	| begin end rubEditor |
	rubEditor := editor editor.
	rubEditor startIndex = 1
		ifTrue: [ ^self ].
	
	begin := rubEditor startIndex - 1.
	end := markStopIndex.
	rubEditor selectFrom: begin to: end.
	markStartIndex := begin.
	markStopIndex := end.
	^ self
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeLeftBelow: aKeyboardEvent [
	| begin end rubEditor |
	rubEditor := editor editor.
	rubEditor stopIndex = 1 
		ifTrue: [ ^ self ].
	
	(rubEditor startIndex) ~= (rubEditor stopIndex)
		ifTrue: [ begin := markIndex. end := (rubEditor stopIndex) - 2 ]
		ifFalse: [ begin := (rubEditor startIndex) - 1. end := (rubEditor stopIndex) - 1 ].
	
	rubEditor selectFrom: begin to: end.
	markStartIndex := begin.
	markStopIndex := end.
	^ self
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeLineBegin: aKeyboardEvent [
 self isAbove 
  ifTrue: [ self charModeLineBeginAbove: aKeyboardEvent ] 
  ifFalse: [ self charModeLineBeginBelow: aKeyboardEvent ].
	^ true
]

{ #category : #initialization }
VimVisualCharMode >> charModeLineBeginAbove: aKeyboardEvent [
	| begin end | 
	(editor editor startIndex) = 1 ifTrue: [ ^ true ].
	begin := self charModeLineBeginStartIndex.
	end   := self markIndex.
	editor editor selectFrom: begin to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeLineBeginBelow: aKeyboardEvent [
	| begin end | 
 	begin := editor startIndex.
	end   := self charModeLineBeginStopIndex.
	editor editor selectFrom: begin to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeLineBeginStartIndex [
	| index str |
	str   := editor editor string.
 	index := str lastIndexOf: (Character cr) startingAt: (editor editor startIndex) ifAbsent: 1.
	^ index = 1 ifTrue: [ index ] ifFalse: [ index + 1 ]
]

{ #category : #initialization }
VimVisualCharMode >> charModeLineBeginStopIndex [
	| index str |
	str   := editor editor string.
	index := self lastEndOfLineIndex: editor editor pointIndex.
	^ index
]

{ #category : #initialization }
VimVisualCharMode >> charModeRight: aKeyboardEvent [
	"l"
	self isAbove
		ifTrue: [ ^self charModeRightAbove: aKeyboardEvent  ]
		ifFalse: [ ^self charModeRightBelow: aKeyboardEvent ].
]

{ #category : #initialization }
VimVisualCharMode >> charModeRightAbove: aKeyboardEvent [
	"l"
	| begin end rubEditor |
	rubEditor := editor editor.
	begin := markStartIndex + 1.
	end := markStopIndex.
	rubEditor selectFrom: begin to: end.
	markStartIndex := begin.
	markStopIndex := end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeRightBelow: aKeyboardEvent [
	"l"
	| begin end rubEditor |
	rubEditor := editor editor.
	begin := markIndex.
	end := markIndex + (rubEditor selection size).
	rubEditor selectFrom: begin to: end.
	markStartIndex := begin.
	markStopIndex := end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeUp: aKeyboardEvent [
	| rubEditor |
	"k"
	rubEditor := editor editor.
	((rubEditor string lineNumberCorrespondingToIndex: markIndex) >= (rubEditor string lineNumberCorrespondingToIndex: rubEditor stopIndex))
		ifTrue: [ self charModeUpAbove: aKeyboardEvent ]
		ifFalse: [ self charModeUpBelow: aKeyboardEvent ].
		^ self
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeUpAbove: aKeyboardEvent [
	| start end rubEditor |
	rubEditor := editor editor.
	start := self charModeUpAboveStartIndex.
	end := markIndex + 1.
	rubEditor selectFrom: start to: end.
	^ self
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeUpAboveStartIndex [ 
	| length index distance currentLineIndex previousLineIndex line offset rubEditor |
	rubEditor := editor editor.
	currentLineIndex := rubEditor string lineNumberCorrespondingToIndex: rubEditor startIndex.
	currentLineIndex = 1 
	 ifTrue: [ ^ rubEditor startIndex ].
	
	previousLineIndex := currentLineIndex - 1.
	
	line := rubEditor string lineNumber: previousLineIndex. 
	distance := self lengthBetweenLastCrAndStopIndex.
	offset := line size min: distance.
	offset := offset + 1. 
	length := [ (((rubEditor string lines) first: (previousLineIndex - 1)) collect: [ :x | 1 + x size ]) sum ].
 	index := 	(previousLineIndex > 1) ifTrue: [ length value + offset ] ifFalse: [ offset ].
	^ index.
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeUpBelow: aKeyboardEvent [
	| start end rubEditor |
	rubEditor := editor editor.
	start := markIndex.
	end := self charModeUpBelowStopIndex.
	rubEditor selectFrom: start to: end.
	^ self
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeUpBelowStopIndex [	 
	| length index distance currentLineIndex nextLineIndex line offset rubEditor |
	rubEditor := editor editor.	
	currentLineIndex := rubEditor string lineNumberCorrespondingToIndex: rubEditor stopIndex.
	currentLineIndex = 1
	 ifTrue: [ ^ rubEditor stopIndex ].
	
	nextLineIndex := currentLineIndex - 1.
	
	line := rubEditor string lineNumber: nextLineIndex. 
	distance := self lengthBetweenLastCrAndStopIndex.
	offset := line size min: distance. 
	length := [ (((rubEditor string lines) first: nextLineIndex - 1) collect: [ :x | 1 + x size ]) sum ].
	index := 	(nextLineIndex > 1) ifTrue: [ length value + offset] ifFalse: [ offset ]. 
	^ index.
	
]

{ #category : #initialization }
VimVisualCharMode >> charModeWORDBegin: aKeyboardEvent [
	| begin end | 
	begin := editor editor startIndex.
	end   := self charModeWORDBeginStopIndex.
	editor selectFrom: begin to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeWORDBeginStopIndex [

	| index str rubEditor |
	rubEditor := editor editor.
	str := rubEditor string.
	index := str
		         findAnySubstring: self separators
		         startingAt: rubEditor pointIndex.
	index = 0 ifTrue: [ index := rubEditor pointIndex ].
	index := str findAnySubstring: self nonSeparators startingAt: index.
	index := index = 0
		         ifTrue: [ rubEditor string size + 1 ]
		         ifFalse: [ index - 1 ].
	^ index
]

{ #category : #initialization }
VimVisualCharMode >> charModeWordBegin: aKeyboardEvent [
	| begin end | 
	begin := editor editor startIndex.
	end   := self charModeWordBeginStopIndex.
	editor editor selectFrom: begin to: end.
	^ self
]

{ #category : #initialization }
VimVisualCharMode >> charModeWordBeginStopIndex [

	| index str rubEditor |
	rubEditor := editor editor.
	str := rubEditor string.
	index := str
		         findAnySubstring: self nonAlphanums
		         startingAt: rubEditor pointIndex.
	index = 0 ifTrue: [ index := rubEditor pointIndex ].
	index := str findAnySubstring: self alphanums startingAt: index.
	index := index = 0
		         ifTrue: [ rubEditor string size + 1 ]
		         ifFalse: [ index - 1 ].
	^ index
]

{ #category : #initialization }
VimVisualCharMode >> copySelectedRegion: aKeyboardEvent [ 
	| rubEditor |
	rubEditor := editor editor.
	rubEditor copySelection.
	rubEditor selectAt: markStartIndex.
	^ self normalMode.
]

{ #category : #initialization }
VimVisualCharMode >> initialize [ 
	keymap := VimVisualCharModeKeymap new.
	keys := ''.
]

{ #category : #initialization }
VimVisualCharMode >> isAbove [ 
	^ (editor editor startIndex) < markIndex
]

{ #category : #initialization }
VimVisualCharMode >> lengthBetweenLastCrAndStartIndex [
	| lastCrIndex |
	lastCrIndex := (editor editor string ) lastIndexOf: (Character cr) startingAt: markStartIndex ifAbsent: 0.
	^ markStartIndex - lastCrIndex .
]

{ #category : #initialization }
VimVisualCharMode >> lengthBetweenLastCrAndStopIndex [
	| lastCrIndex |
	lastCrIndex := (editor editor string ) lastIndexOf: (Character cr) startingAt: markStopIndex ifAbsent: 0.
	^ markStopIndex - lastCrIndex .
]

{ #category : #initialization }
VimVisualCharMode >> nonAlphanums [
	^ Character allCharacters reject: [ :x | x isAlphaNumeric ]
]

{ #category : #initialization }
VimVisualCharMode >> nonSeparators [
	^ Character allCharacters reject: [ :x | x isSeparator ]
]

{ #category : #initialization }
VimVisualCharMode >> separators [
	^ Character separators
	
]

{ #category : #initialization }
VimVisualCharMode >> undo: aKeyboardEvent [
	"u"
	editor editor selectAt: markIndex.
	^self normalMode.
]

{ #category : #initialization }
VimVisualCharMode >> visualCharMode: anEditor [
	| mode |
	mode := self class visualCharMode.
	mode markIndex: editor editor pointIndex.
	mode markStartIndex: markIndex.
	mode markStopIndex: markIndex.
	editor editor selectFrom: markIndex to: markIndex.
	^ mode
]

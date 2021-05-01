Class {
	#name : #VimAbstractMode,
	#superclass : #Object,
	#instVars : [
		'editor',
		'keymap',
		'times',
		'keys',
		'markIndex',
		'markStartIndex',
		'markStopIndex'
	],
	#category : #PharoVimMode
}

{ #category : #'as yet unclassified' }
VimAbstractMode class >> insertMode [ 
	^ VimInsertMode  new
]

{ #category : #'as yet unclassified' }
VimAbstractMode class >> normalMode [ 
	^ VimNormalMode new
]

{ #category : #'as yet unclassified' }
VimAbstractMode class >> visualCharMode [
	^ VimVisualCharMode new
]

{ #category : #'as yet unclassified' }
VimAbstractMode class >> visualCharMode: anEditor [
	| mode index |
	mode := self visualCharMode.
	index := anEditor pointIndex.
	mode markIndex: index.
	mode markStartIndex: index.
	mode markStopIndex: index.
	^mode
]

{ #category : #'as yet unclassified' }
VimAbstractMode class >> visualLineMode [
  ^ VimVisualLineMode new
]

{ #category : #'as yet unclassified' }
VimAbstractMode class >> visualLineMode: anEditor [
 | mode index |
 mode := self visualLineMode.
 index := anEditor pointIndex.
 mode markIndex: index.
 mode markStartIndex: index.
 mode markStopIndex: index.
 ^ mode
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> cursorBackwardWORDBeginIndex: aKeyboardEvent [
	| str index |
 str   := editor string.
	index := editor pointIndex.
	
	index = ((str size) + 1) & index = 1
	 ifTrue: [ ^ index ].
	
	index > str size
	 ifTrue: [ index := str size ].
	
	index > 1 
		 ifTrue: [((str at: index) isSeparator not)
			          ifTrue: [index := index - 1]].
	
	[ index > 1 
		 ifTrue: [(str at: index) isSeparator]
		 ifFalse: [false]]
			whileTrue: [index := index - 1].
			
	index = 1 
	 ifTrue: [ ^ index ].
						
	[ index >= 1 
		 ifTrue: [(str at: index) isSeparator not]
		 ifFalse: [false]]
			whileTrue: [index := index - 1].
			
	^ index + 1. 
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> cursorBackwardWordBeginIndex: aKeyboardEvent [
	| str index |
 str   := editor string.
	index := editor pointIndex.
	
	index = ((str size) + 1) & index = 1
	 ifTrue: [ ^ index ].
	
	index > str size
	 ifTrue: [ index := str size ].
	
	index > 1 
		 ifTrue: [(str at: index) isAlphaNumeric
			          ifTrue: [index := index - 1]].
	
	[ index > 1 
		 ifTrue: [(str at: index) isAlphaNumeric not]
		 ifFalse: [false]]
			whileTrue: [index := index - 1].
			
	index = 1 
	 ifTrue: [ ^ index ].
						
	[ index > 1 
		 ifTrue: [(str at: index) isAlphaNumeric]
		 ifFalse: [false]]
			whileTrue: [index := index - 1].
	^ index + 1
]

{ #category : #'editing keys' }
VimAbstractMode >> cut: aKeyboardEvent [ 
	editor cut.
	^ self normalMode.
]

{ #category : #accessing }
VimAbstractMode >> editor [

	^ editor
]

{ #category : #accessing }
VimAbstractMode >> editor: anObject [

	editor := anObject
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> endOfLineIndex: characterIndex [
	^ editor string indexOf: (Character cr) startingAt: characterIndex ifAbsent: (editor string size) + 1.


]

{ #category : #'as yet unclassified' }
VimAbstractMode >> handleInput: aKeyboardEvent for: anEditor [
	| key action newMode |
	editor := anEditor. 
	key := Character value: aKeyboardEvent keyValue.
	action := (keymap keymap) at: key ifAbsent: [ #noop: ].
	Transcript
		show: action;
		cr.
	action == #noop:
		ifTrue: [ keys := ''. ].
	newMode := action asString endsWithAColon
		ifTrue: [ self perform: action with: aKeyboardEvent ]
		ifFalse: [ self perform: action ].
	^ newMode
]

{ #category : #mode }
VimAbstractMode >> insertMode [
 ^ self class insertMode


]

{ #category : #accessing }
VimAbstractMode >> keymap [

	^ keymap
]

{ #category : #accessing }
VimAbstractMode >> keymap: anObject [

	keymap := anObject
]

{ #category : #accessing }
VimAbstractMode >> keys [

	^ keys
]

{ #category : #accessing }
VimAbstractMode >> keys: anObject [

	keys := anObject
]

{ #category : #accessing }
VimAbstractMode >> lastEndOfLineIndex: characterIndex [
 | index |
 index := ((characterIndex = ((editor string size) + 1)) or: [(editor string at: characterIndex) = (Character cr)])
  ifTrue: [ characterIndex - 1]
  ifFalse: [ characterIndex ].
	^ editor string lastIndexOf: (Character cr) startingAt: index ifAbsent: 0.
]

{ #category : #accessing }
VimAbstractMode >> markIndex [

	^ markIndex
]

{ #category : #accessing }
VimAbstractMode >> markIndex: anObject [

	markIndex := anObject
]

{ #category : #accessing }
VimAbstractMode >> markStartIndex [

	^ markStartIndex
]

{ #category : #accessing }
VimAbstractMode >> markStartIndex: anObject [

	markStartIndex := anObject
]

{ #category : #accessing }
VimAbstractMode >> markStopIndex [

	^ markStopIndex
]

{ #category : #accessing }
VimAbstractMode >> markStopIndex: anObject [

	markStopIndex := anObject
]

{ #category : #'editing keys' }
VimAbstractMode >> noop: aKeyboardEvent [
	^self
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> normalMode [
	^ self class normalMode
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> selectWholeLine [
 | begin end str | 
 str := editor string.
 begin := self lastEndOfLineIndex: editor pointIndex.
 end := self endOfLineIndex: editor pointIndex.
 begin = 1 | end = 1
  ifTrue: [ editor selectAt: 1. ^ true ] .
 (end - begin) = 1 & end = (editor string size + 1) 
  ifTrue: [ editor selectAt: end. ^ true ].
 begin = 1 
  ifFalse: [ begin := begin + 1].
 end := end - 1.
 editor selectFrom: begin to: end.
 ^ true
]

{ #category : #accessing }
VimAbstractMode >> times [

	^ times
]

{ #category : #accessing }
VimAbstractMode >> times: anObject [

	times := anObject
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> visualCharMode [
 ^ self class visualCharMode
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> visualCharMode: anEditor [
 | mode |
 mode := self class visualCharMode.
 mode markIndex: editor pointIndex.
 mode markStartIndex: markIndex.
 mode markStopIndex: markIndex.
 ^ mode
]

{ #category : #'as yet unclassified' }
VimAbstractMode >> visualLineMode [
 ^ self class visualLineMode
]

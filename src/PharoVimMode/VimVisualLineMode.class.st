Class {
	#name : #VimVisualLineMode,
	#superclass : #VimAbstractMode,
	#category : #'PharoVimMode-Vim'
}

{ #category : #copying }
VimVisualLineMode >> copySelectedLines: aKeyboardEvent [
	| text rubEditor |
	rubEditor := editor editor.
	text := rubEditor selection , String cr.
	rubEditor clipboardTextPut: text.
	rubEditor selectAt: markStartIndex.
	^ self normalMode
]

{ #category : #initialization }
VimVisualLineMode >> initialize [
 keymap := VimVisualLineModeKeymap new.
 keys := ''.
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkBufferBegin: aKeyboardEvent [
	| begin end rubEditor |
	rubEditor := editor editor.
	begin := 1.
	end   := (rubEditor stopIndex) - 1.
	rubEditor selectFrom: begin to: end.
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkBufferEnd: aKeyboardEvent [
	| begin end rubEditor |
	rubEditor := editor editor.	
	begin := rubEditor startIndex.
	end := (rubEditor string size) + 1.
	rubEditor selectFrom: begin to: end.
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkDown: aKeyboardEvent [
	"j"
	"Halt now."
	| rubEditor |
	rubEditor := editor editor.
   markStartIndex = editor startIndex "| (((markStartIndex - 1) = editor startIndex) & markStopIndex = editor stopIndex)"
	   ifTrue: [ ^ self lineModeMarkDownBelow: aKeyboardEvent ].

	markStopIndex = editor stopIndex
		ifTrue: [ ^ self lineModeMarkDownAbove: aKeyboardEvent ]
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkDownAbove: aKeyboardEvent [
	"j"
	| begin end rubEditor |
	rubEditor := editor editor.
	begin := self endOfLineIndex: (rubEditor startIndex). 
 	begin ~= 1 
  		ifTrue: [ begin := begin + 1 ]. 
 	end := rubEditor stopIndex.
	rubEditor selectFrom: begin to: end - 1.
	^ self
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkDownBelow: aKeyboardEvent [
	"j"
	| begin end rubEditor | 
	rubEditor := editor editor.
	begin := rubEditor startIndex.
 	rubEditor stopIndex = (rubEditor string size + 1) 
		ifTrue: [ ^ self ]. 
	end := self endOfLineIndex: (rubEditor stopIndex + 1).
	rubEditor selectFrom: begin to: end - 1.
	^ self
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkUp: aKeyboardEvent [
	"k"
	markStopIndex = editor stopIndex
		ifTrue: [ ^ self lineModeMarkUpAbove: aKeyboardEvent ]. 
	markStartIndex = editor startIndex 
		ifTrue: [ ^ self lineModeMarkUpBelow: aKeyboardEvent ].
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkUpAbove: aKeyboardEvent [
	"k" 
	| begin end rubEditor |
	rubEditor := editor editor.
	end := rubEditor stopIndex.
	rubEditor startIndex = 1 
		ifTrue: [ ^ self ]. 
	begin := self lastEndOfLineIndex: (rubEditor startIndex - 1).
	rubEditor selectFrom: begin + 1 to: end - 1.
	^ self
]

{ #category : #copying }
VimVisualLineMode >> lineModeMarkUpBelow: aKeyboardEvent [
	"k" 
 	| begin end rubEditor |
	rubEditor := editor editor.
 	begin := rubEditor startIndex.
 	end := self lastEndOfLineIndex: (rubEditor stopIndex - 1).
	rubEditor selectFrom: begin to: end - 1.
	^ self
]

{ #category : #copying }
VimVisualLineMode >> undo: aKeyboardEvent [
	"u"
	editor editor selectAt: markIndex.
	^self normalMode
]

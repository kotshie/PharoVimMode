Extension { #name : #RubEditingArea }

{ #category : #'*PharoVimMode' }
RubEditingArea >> click: anEvent [
	| handled |
	handled := super click: anEvent.
	Transcript crShow: anEvent.
	self updateCursorStyle.
	^handled
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> focusChanged [ 
	Transcript crShow: 'Focus Changed'.
	super focusChanged.
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeyUp: anEvent [

	self vim enabled ifTrue: [ 
		anEvent keyCharacter == Character escape 
			ifTrue:  [ 
				self vim agent mode: VimAbstractMode normalMode.
				self updateCursorStyle.
			]
	].
	super handleKeyUp: anEvent
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeystroke: aKeystroke [
	| handled |
	handled := false.
	self vim enabled ifTrue: [ 
		handled := self vim agent handleInput: aKeystroke  for: self.
	].
	handled 
		ifTrue: [ self updateCursorStyle  ]
		ifFalse: [  super handleKeystroke: aKeystroke ]
	
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> updateCursorStyle [

	| isVimEnabled isDarkMode cursorColor cursorWidth |
	isVimEnabled := self vim enabled.
	isDarkMode := self theme isKindOf: PharoLightTheme.

	isVimEnabled
		ifFalse: [ 
			cursorColor := isDarkMode
				               ifTrue: [ Color lightGray ]
				               ifFalse: [ Color darkGray ].
			cursorWidth := 2 ]
		ifTrue: [ 
			self vim agent isNormalMode
				ifTrue: [ " Normal Mode "
					cursorColor := isDarkMode
						               ifTrue: [ Color lightGray ]
						               ifFalse: [ Color darkGray ].
					cursorWidth := 8 ]
				ifFalse: [ " Insert Mode and other modes"
					cursorColor := isDarkMode
						               ifTrue: [ Color lightGray ]
						               ifFalse: [ Color darkGray ].
					cursorWidth := 2 ] ].

	self cursor visibleCursorColor: cursorColor.
	self cursor width: cursorWidth
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> vim [ 
	^ VimState uniqueInstance 
]

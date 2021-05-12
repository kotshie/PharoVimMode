Extension { #name : #RubEditingArea }

{ #category : #'*PharoVimMode' }
RubEditingArea >> click: anEvent [
	Transcript crShow: anEvent.
	self updateCursorStyle.
	^ super click: anEvent
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
	self vim enabled
		ifFalse: [ 
			Transcript crShow: 'Vim Mode OFF'.
			self cursor visibleCursorColor: Color lightGray.
			self cursor width: 2.
		 ]
		ifTrue:  [ 
			self vim agent isNormalMode 
				ifTrue: [
					" Normal Mode "
					Transcript crShow: 'Normal Mode'.
					self cursor visibleCursorColor:  Color lightGreen.
					self cursor width: 8.
					 ]
				ifFalse: [ 
					" Insert Mode and other modes"
					Transcript crShow: 'insert Mode'.
					self cursor visibleCursorColor:  Color lightGreen.
					self cursor width: 2.
				].
		].
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> vim [ 
	^ VimState uniqueInstance 
]

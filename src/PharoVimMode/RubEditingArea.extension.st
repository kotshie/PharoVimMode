Extension { #name : #RubEditingArea }

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeyUp: anEvent [
	self vim enabled ifTrue: [ 
		Transcript crShow: anEvent.
	].
	super handleKeyUp: anEvent
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeystroke: anEvent [
	self vim enabled ifTrue: [ 
		self vim agent isNormalMode ifTrue: [ 
			self halt.
			Transcript crShow: anEvent.
		].
	].
	super handleKeystroke: anEvent
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> updateCursorStyle: aRubCursor [

]

{ #category : #'*PharoVimMode' }
RubEditingArea >> vim [ 
	^ VimState uniqueInstance 
]

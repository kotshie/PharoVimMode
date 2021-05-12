Extension { #name : #RubEditingArea }

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeyUp: anEvent [
	self vim enabled ifTrue: [ 
		Transcript crShow: anEvent.
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
	handled ifFalse: [  super handleKeystroke: aKeystroke ]
	
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> updateCursorStyle: aRubCursor [

]

{ #category : #'*PharoVimMode' }
RubEditingArea >> vim [ 
	^ VimState uniqueInstance 
]

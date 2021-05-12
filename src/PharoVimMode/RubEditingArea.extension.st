Extension { #name : #RubEditingArea }

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeyUp: anEvent [
	Transcript crShow: anEvent.
	super handleKeyUp: anEvent
]

{ #category : #'*PharoVimMode' }
RubEditingArea >> handleKeystroke: anEvent [
	Transcript crShow: anEvent.
	super handleKeystroke: anEvent
]

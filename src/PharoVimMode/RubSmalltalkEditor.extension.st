Extension { #name : #RubSmalltalkEditor }

{ #category : #'*PharoVimMode' }
RubSmalltalkEditor >> click: anEvent [
	| vimAgent |
	vimAgent := self vim agent.
	"self selectorChooserClose"
	Transcript show: anEvent; cr.
	" If Vim Enabled "
	self isVimEnabled ifTrue: [ 
		((vimAgent isNil not) and: [ vimAgent isNormalMode not ])
			ifTrue: [ vimAgent mode: VimAbstractMode normalMode ].
	].
	" Else do normal behaviour "
	^ super click: anEvent
]

{ #category : #'*PharoVimMode' }
RubSmalltalkEditor >> dispatch: aKeyboardEvent [
	self isVimEnabled ifTrue: [ 
		(self vim: aKeyboardEvent return: [:value | ^value ]) ifTrue: [^ true].
	].
	^ super dispatch: aKeyboardEvent.
]

{ #category : #'*PharoVimMode' }
RubSmalltalkEditor >> isVimEnabled [
	^false
]

{ #category : #'*PharoVimMode' }
RubSmalltalkEditor >> vim [
	^ VimState uniqueInstance
	
	 
]

{ #category : #'*PharoVimMode' }
RubSmalltalkEditor >> vim: aKeyboardEvent return: aBlock [
	^ (self vim agent) handleInput: aKeyboardEvent for: self.
]

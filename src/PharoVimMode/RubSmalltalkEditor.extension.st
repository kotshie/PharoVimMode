Extension { #name : #RubSmalltalkEditor }

{ #category : #'*PharoVimMode' }
RubSmalltalkEditor >> click: anEvent [
	"self selectorChooserClose"
	Transcript show: anEvent; cr.
	" If Vim Enabled "
	self isVimEnabled ifTrue: [ 
		((vim isNil not) and: [  vim isNormalMode not ])
			ifTrue: [ vim mode: VimAbstractMode normalMode ].
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
RubSmalltalkEditor >> vim: aKeyboardEvent return: aBlock [
	vim ifNil: [  vim := VimAgent new ].
	^ vim handleInput: aKeyboardEvent for: self.
]

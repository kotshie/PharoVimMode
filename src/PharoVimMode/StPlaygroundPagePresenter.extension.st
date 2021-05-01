Extension { #name : #StPlaygroundPagePresenter }

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> createToggleVimModeButton [
	(self vim) toggleVimModeButton: statusbar.
	^ self vim toggleVimModeButton
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> initializeStatusbar [ 

	(statusbar := self instantiate: SpPresenter)
		layout: (SpBoxLayout newHorizontal
			borderWidth: 3;
			vAlignCenter;
			add: (lineLabel := statusbar newLabel) expand: false;
			addLast: (toggleLineNumberButton := statusbar newToggleButton) expand: false;
			addLast: (self createToggleVimModeButton) expand: false;
			yourself).

	lineLabel addStyle: 'dim'.

	toggleLineNumberButton
		label: (StShowLineNumbersCommand iconLabelFor: self showLineNumbers);
		help: StShowLineNumbersCommand defaultDescription;
		state: self showLineNumbers;
		whenChangedDo: [ :state | self showLineNumbers: state ].
	
	(self toggleVimModeButton)
		label: (StVimEnableCommand iconLabelFor: self vimModeEnabled );
		help: StVimEnableCommand defaultDescription;
		state: self vimModeEnabled;
		whenChangedDo: [ :state | self vimModeEnabled: state ].
	
	self vimModeEnabled: (self vim enabled).

]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> toggleVimModeButton [
	^ self vim toggleVimModeButton.
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> vim [
	^ VimState uniqueInstance 
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> vimModeEnabled [
	^self vim enabled
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> vimModeEnabled: aBoolean [
	self vim enabled: aBoolean
]

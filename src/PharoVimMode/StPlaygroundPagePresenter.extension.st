Extension { #name : #StPlaygroundPagePresenter }

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> enableVimMode [
	^ vimMode not
	
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> initializeStatusbar [ 

	(statusbar := self instantiate: SpPresenter)
		layout: (SpBoxLayout newHorizontal
			borderWidth: 3;
			vAlignCenter;
			add: (lineLabel := statusbar newLabel) expand: false;
			addLast: (toggleLineNumberButton := statusbar newToggleButton) expand: false;
			addLast: (toggleVimModeButton := statusbar newToggleButton ) expand: false;
			yourself).

	lineLabel addStyle: 'dim'.

	toggleLineNumberButton
		label: (StShowLineNumbersCommand iconLabelFor: self showLineNumbers);
		help: StShowLineNumbersCommand defaultDescription;
		state: self showLineNumbers;
		whenChangedDo: [ :state | self showLineNumbers: state ].
		
	toggleVimModeButton
		label: (StVimEnableCommand iconLabelFor: self enableVimMode );
		help: StVimEnableCommand defaultDescription;
		state: self enableVimMode;
		whenChangedDo: [ :state | self vimMode: state ].

]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> vimMode [
	^vimMode
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> vimMode: aBoolean [
	^vimMode := aBoolean
]

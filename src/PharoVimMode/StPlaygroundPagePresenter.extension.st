Extension { #name : #StPlaygroundPagePresenter }

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> initializeStatusbar [

	| toggleVimModeButton |
	(statusbar := self instantiate: SpPresenter) layout:
		(SpBoxLayout newHorizontal
			 borderWidth: 3;
			 vAlignCenter;
			 add: (lineLabel := statusbar newLabel) expand: false;
			 addLast: (toggleLineNumberButton := statusbar newToggleButton)
			 expand: false;
			 yourself).

	toggleVimModeButton := statusbar newToggleButton.
	statusbar layout addLast: toggleVimModeButton expand: false.

	lineLabel addStyle: 'dim'.

	toggleLineNumberButton
		label: (StShowLineNumbersCommand iconLabelFor: self showLineNumbers);
		help: StShowLineNumbersCommand defaultDescription;
		state: self showLineNumbers;
		whenChangedDo: [ :state | self showLineNumbers: state ].

	toggleVimModeButton
		label: (StVimEnableCommand iconLabelFor: self vim enabled);
		help: StVimEnableCommand defaultDescription;
		state: self vim enabled;
		whenChangedDo: [ :state | 
			self updateVimMode: state .
		].

]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> updateVimMode: aBoolean [
	self vim enabled: aBoolean
]

{ #category : #'*PharoVimMode' }
StPlaygroundPagePresenter >> vim [
	^ VimState uniqueInstance 
]

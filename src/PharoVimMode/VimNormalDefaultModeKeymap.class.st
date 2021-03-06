Class {
	#name : #VimNormalDefaultModeKeymap,
	#superclass : #VimKeymap,
	#category : #'PharoVimMode-Vim'
}

{ #category : #accessing }
VimNormalDefaultModeKeymap >> keymap [ 
| assocs cmdMap |
	cmdMap := Dictionary new.
	0 to: 255 do: [ :i |
	  cmdMap at: (Character value: i) put: #noop: ].
	assocs := {  
 "Navigation keys"
	  ($h -> #cursorLeft:).
	  ($l -> #cursorRight:).
	  ($j -> #cursorDown:).
	  ($k -> #cursorUp:). 
	  ($w -> #cursorWordBegin:).
	  ($W -> #cursorWORDBegin:).
	  ($e -> #cursorWordEnd:).
	  ($E -> #cursorWORDEnd:).
		 ($b -> #cursorBackwardWordBegin:).
	  ($B -> #cursorBackwardWORDBegin:).
		 ($0 -> #cursorLineBegin:).
	  ($$ -> #cursorLineEnd:). 
		 ($^ -> #cursorLineBeginNoneEmpty:).
	  (Character arrowLeft -> #cursorLeft:).
	  (Character arrowRight -> #cursorRight:).
	  (Character arrowUp -> #cursorUp:).
	  (Character arrowDown -> #cursorDown:).

 "Insert text"
	  ($i -> #insertBeforeCursor:).
	  ($I -> #insertAtBeginOfLine:).
	  ($a -> #insertAfterCursor:).
	  ($A -> #insertAtEndOfLine:).
	  ($o -> #appendNewLine:).
	  ($O -> #insertNewLine:).
	
	"Delete text" 
	  ($x -> #forwardDelete:).

	"Simple replace text" 
	  ($r -> #replaceCharacter:).  

	"Copy/Paste text"
	  	($Y -> #copyLine:).
	  ($p -> #pasteText:). 

 "Undo/Redo operation"
	  ($u -> #undo).
	  ((Character value: 18) -> #redoChanges:). "ctrl + $r" 

	  ($v -> #enableVisualLineMode:). "$v"
	  "($V -> #enableVisualLineMode:)." "$V"
	  "((Character value: 22) -> #tryVisualBlockMode:)." "ctrl + $v"

   ($* -> #emphasisWordUnderCursor:). 

   ($/ -> #comment:).
	
	 	 }.
	assocs do: [ :assoc |
		   cmdMap at: assoc key put: assoc value ].
	^ cmdMap
]


❌ - Not Working
⚠️ - Don't know.
✅ - Works

source: https://vim.rtorr.com/


## Cursor Movement
| Key | Description | Works |
--- | --- | ---
| h | move cursor left | ✅ |
| j | move cursor down | ✅ |
| k | move cursor up | ✅ |
| l | move cursor right | ✅|
| H | move to top of screen | ⚠️ |
| M | move to middle of screen | ⚠️ |
| L | move to bottom of screen | ⚠️|
| w | jumps to the start of the word | ✅ |
| W | jumps to the start of the word (contains punctuation) | ⚠️|
| e | jump forwards to the end of a word | ⚠️|
| E | jump forwards to the end of a word (contains punctuation) | ⚠️|
| b | jump backwards to the start of a word | ⚠️|
| B | jump backwards to the start of a word (contains punctuation) | ⚠️|
| % | move to matching character (default: '()' '[]') | ⚠️|
| 0 | jump to the start of line | ⚠️|
| ^ | jump to the first non-blank character of the line | ⚠️|
| $ | jump to the end of the line | ⚠️|
| g_ | jump to the last non-blank character of the line | ⚠️|
| gg | go to the first line of the document | ⚠️|
| G | go to the last line of the document | ⚠️|
| 5gg or 5G | go to line 5 | ⚠️|
| gd | move to local declaration | ⚠️|
| gD | move to global declaration | ⚠️|
| fx | jump to next occurrence of character x | ⚠️|
| tx | jump to before occurrence of character x | ⚠️|
| Fx | jump to previous occurence of character x | ⚠️|
| Tx | jump to after previous occurence of character x | ⚠️|
| ; | repeat previous f, t, F or T movement | ⚠️|
| , | repeat previous f, t, F or T movement, backwards | ⚠️|
| } | jump to next paragraph (or function/block, when editing code) | ⚠️|
| { | jump to previous paragraph (or function/block, when editing code) | ⚠️|
| zz | center cursor on screen | ️|
| Ctrl + e | Move screen down one line (without moving cursor) | ⚠️|
| Ctrl + y | Move screen up one line (without moving cursor) | ⚠️|
| Ctrl + b | Move back one full screen | ⚠️|
| Ctrl + f | Move forward one full screen | ⚠️|
| Ctrl + d | Move forward 1/2 a screen | ❌|
| Ctrl + u | Move back 1/2 a screen | ❌|


## Insert Mode
| Key | Description | Works |
--- | --- | ---
| i | insert before the cursor | ✅ |
| I | insert at the beginning of the line | ⚠️ |
| a | insert (append) after the cursor | ⚠️ |
| A | insert (append) at the end of the line | ✅ |
| o | append (open) a new line below the current line | ⚠️ |
| O | append (open) a new line above the current line | ⚠️ |
| ea | insert (append) at the end of the word | ⚠️ |
| Ctrl + h | delete the character before the cursor during insert mode| ⚠️ |
| Ctrl + w | delete word before cursor during insert mode | ⚠️ |
| Ctrl + j | begin new line during insert mode | ⚠️ |
| Ctrl + t | indent (move right) line on shiftwidth during insert mode | ⚠️ |
| Ctrl + d | de-indent (move left) line one shiftwidth during insert mode | ⚠️ |
| Ctrl + n | insert (auto complete) next match before the cursor during insert mode | ⚠️ |
| Ctrl + p | insert (auto complete) previous match before the cursor during insert mode | ⚠️ |
| Ctrl + rx | insert the contents of register x | ⚠️ |
| Esc | Exit insert mode | ✅ |


## Editing
| Key | Description | Works |
--- | --- | ---
| r | replace a single character | ✅ |
| J | join line below to the current one with one space in between | ⚠️ |
| gJ | join line below to the current one without space in between | ⚠️ |
| gwip | reflow paragraph | ❌ |
| g~ | switch case up to motion | ❌ |
| gu | change to lowercase up to motion | ❌ |
| gU | change to uppercase up to motion | ❌ |
| cc | change (replace) entire line | ❌ |
| C | change (replace) to the end of the line | ❌ |
| c$ | change (replace) to the end of the line | ❌ |
| ciw | change (replace) entire word | ❌ |
| cw | change (replace) to the end of word | ❌ |
| s | delete character and substitute text | ❌ |
| S | delete line and substitute text (same as cc) | ❌ |
| xp | transpose two letters (delete and paste) | ❌ |
| u | undo | ⚠️ |
| U | restore(undo) last changed line| ⚠️ |
| Ctrl + r | redo | ⚠️ | 
| . | repeat last command | ❌ |


## Marking Text
| Key | Description | Works |
--- | --- | ---
| v | start visual mode, mark lines, etc.. | ✅ | 
| V | start linewise visual mode | ❌ | 
| o | move to other end of marked area | ❌ | 
| Ctrl + v | Start visual block mode | ❌ | 
| O | move to other corner of block | ❌ | 
| aw | mark a word | ❌ | 
| ab | a block with () | ❌ | 
| aB | a block with {} | ❌ | 
| at | a block with <> | ❌ | 
| ib | inner block with () | ❌ | 
| iB | inner block with {} | ❌ | 
| it | inner block with <> | ❌ | 
| Esc | exit visual mode | ✅ |




## Copy and Paste
| Key | Description | Works |
--- | --- | ---
| yy | yank (copy) a line | ✅ |
| 2yy | yank (copy) 2 lines |❌|
| yw | yank (copy) characters of the word from the cursor position | ❌ |
| y$ | yank to end of line | ❌ |
| p | put (paste) the clipboard after cursor | ✅ |
| P | put (paste) the clipboard before cursor | ❌ |
| dd | delete (cut) a line | ✅ |
| 2dd | delete (cut) 2 lines |❌|
| dw | delete (cut) the characters of the word from the cursor position | ❌ |
| D | delete (cut) to the end of the line |  ❌ | 
| d$| delete (cut) to the end of the line |  ❌|
| x | delete (cut) character | ✅ |

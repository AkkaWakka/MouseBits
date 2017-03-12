## Description:
This mod currently adds two hotkeys that allow you to restrict the placement of items in the x or y directions. There is a third hotkey that restricts placement to diagonal lines (x=y & x=-y).

The first item placed will set the placement 'base', and further items will only be placed on the same x, y, or diagonal as the base item. You can place items at an offset from the allowed line and they will automagically be placed on on the allowed line at the closest point. You cannot place items beyond your reach.

Pressing a hotkey will toggle its restriction, while changing or rotating the held item will reset the base.

## Default Hotkeys
- Restrict to X line: Shift + X
- Restrict to Y line: Shift + Y
- Restrict to diagonals: Shift + D

## Known Quirks/Issues:
- Extra sounds and dust sprites when placing something. This is due to the way the building restriction is applied (entities are copied, and the original is deleted).

## Planned Features
- Add a hotkey to remove all restrictions.
- Add a simple GUI to display the currently selected restriction (if any) and allow toggling with the mouse.
- Support for placement in patterns (e.g. only place every 5th or only 2 out of 4 (I'm looking at you inserters), etc.). This may involve some technology, but I'm not looking to replace blueprints.

## Changelog.
#### 0.1.0 - Initial Commit.
- Added restrictions for X, Y, and Diagonals.
## 0.1.1 - Quirk Fixes
- Held item rotation reset base.
- Made hotkeys togglable.  No more permanently in restricted mode! :)
- Fixed the docs: changing items only resets the base.

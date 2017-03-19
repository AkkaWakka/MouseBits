## Description:
Lets you restrict item placement in North/South, East/West, and diagonal lines Northeast/Southwest & Northwest/Southeast), making it easier to place things in straight lines without having to hold the mouse still and walk in a direction.

The first item placed sets the base for the restriction, with further items only allowed on the same x, y, or diagonal line as the base.

Items placed at an offset from the allowed line will be moved to the allowed line at the closest point from where you placed the item. You cannot place items beyond your reach.

Placement restrictions can be controlled with either hotkeys or a GUI, and will be reset when your hand empties, or you change or rotate items.

If you have any comments, suggestions, etc., I'd really appreciate your feedback: [Factorio Forum Post](https://forums.factorio.com/viewtopic.php?f=97&t=42641) | [GitHub Issues](https://github.com/AkkaWakka/MouseBits/issues).

## Controls:
Pressing a hotkey will enable its restriction (regardless of what restriction is currently active), pressing the same hotkey again will reset the base.  Pressing the reset button will remove any active restriction.  There is a hotkey to reset only the item base.

The GUI can be accessed by pressing the mouse pointer button on the left of the screen.  It has toggles for all the restrictions, and will indicate the current restriction state.  Clicking an already applied restriction will reset the base.  Pressing the remove restriction button will remove any active restriction.

## Default Hotkeys:
- Restrict to X line: Shift + X
- Restrict to Y line: Shift + Y
- Restrict to diagonals: Shift + D
- Remove all restrictions: Shift + R
- Reset base: Left Shift

## Known Quirks/Issues:
- Extra sounds and dust sprites when placing something. This is due to the way the building restriction is applied (entities are copied, and the original is deleted).

## Planned Features:
- Support for placement in patterns (e.g. only place every 5th or only 2 out of 4 (I'm looking at you inserters), etc.). This may involve some technology, but I'm not looking to replace blueprints.
- Definable gap between placements (e.g. every 3 tiles).  Would be nice to tie this in with the patterns idea (e.g. a 5 tile patter is repeated every 10 tiles).
- Click and drag settings copying (Shift + Right Click -> Shift + Left Click).

## Changelog:
#### 0.1.0 - Initial Commit
- Added restrictions for X, Y, and Diagonals.

#### 0.1.1 - Quirk Fixes
- Held item rotation resets base.
- Made hotkeys togglable.  No more permanently in restricted mode! :)
- Fixed the docs: changing items only resets the base.

#### 0.2.0 - GUI Added
- Added simple GUI to indicate restriction state.
- Added hotkey to reset all restrictions.
- Basic code refactor.

#### 0.2.1 - Usability Tweaks
- Restriction buttons now only turn their restriction on.
- Restrictions aren't reset when your hand is no longer empty.

### 0.2.2 - Fixes/Usability
- Swapped axis restrictions so they're more intuitive (+ some renaming).
- Added a hotkey/click to reset the base only.
- Accidentally fixed an bad function reference that caused issues with Factorissimo.  Yay for refactoring.

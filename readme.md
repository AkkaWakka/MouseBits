## Description:
Makes life easier by letting you just click and drag!

- Restrict placement to either Up/Down, Left/Right, or Diagonals.
- Define and place entities in simple patterns without having to place everything individually.

The first item placed sets the base.
- If you've enable an axis restriction, entities not placed on the same x, y, or diagonal line as the base will be moved to that line (e.g. long belts).
- If you've defined a pattern, entities are only placed if they fit the pattern (e.g. inserters).
- If you've set a spacing, entities will only be placed that far apart (e.g. chemical plants).

You can have any combination of these.  For example, inserters placed every 2 tiles apart, skipping every 6th inserter, in a diagonal line.

Everything can be set through a simple GUI, or hotkeys to set the axis restrictions and reset everything.

If you have any comments, suggestions, etc., I'd really appreciate your feedback: [Factorio Forum Post](https://forums.factorio.com/viewtopic.php?f=97&t=42641) | [GitHub Issues](https://github.com/AkkaWakka/MouseBits/issues).

## Controls:
The GUI can be accessed by clicking the mouse pointer button on the top of the screen.  Changing anything will reset the base.  Pressing the remove restriction button will remove all active restrictions/patterns.

Pressing a hotkey will enable that restriction (regardless of what axis restriction is currently active), pressing the same hotkey again will reset the base.  Pressing the reset button will remove any axis & pattern restriction.  There is a hotkey to reset only the item base.

Spacing will add space between every item in a pattern (not between patterns), including blanks.  To get an idea of how this works, use an 8 entity pattern with only 1 blank in the middle, and spacing set to 1.

You cannot place items beyond your reach.

## Default Hotkeys:
- Restrict to X line: Shift + X
- Restrict to Y line: Shift + Y
- Restrict to diagonals: Shift + D
- Remove all restrictions: Shift + R
- Reset base: Left Shift

## Known Quirks/Issues:
- Extra sounds and dust sprites when placing something. This is due to the way the building restriction is applied (entities are copied, and the original is deleted).

## Planned Features:
- Tech to increase the max number of pattern slots (probably starting at 4 and finishing at 8).  Either way, patterns will always be unlocked.
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

#### 0.2.2 - Fixes/Usability
- Swapped axis restrictions so they're more intuitive (+ some renaming).
- Added a hotkey/click to reset the base only.
- Accidentally fixed an bad function reference that caused issues with Factorissimo.  Yay for refactoring.

#### 0.2.3 - Hotkey Quick Fix
- Hotkey Derp.  Fixed Now.

#### 0.3.0 - Patterns!
- Added patterns of up to 8 entities in a straight line.
- Added spacing between entites.

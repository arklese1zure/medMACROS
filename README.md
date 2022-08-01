# MedMACROS
Small and extensible helper application for writing medical notes during consultation, written in AutoHotKey.

## Current functionality
### Extensibility via plug-ins
MedMacros extensions are specially formatted Autohotkey scripts that can be used for augmenting the main script's own capabilities.
Some examples of extensibility:
- Add new sections to the main GUI via tabs.
- Add new features to the text editor.
- Add new options to menus.
- Add new sets of hostrings via specially formatted "dictionaries".
- Add new global hotkeys with custom actions (for example, navigating cumbersome menus via automated keystroke sequences).
- Create specific keystroke sequences for quick navigation of menus or performing repetitive tasks.

### Hotstring manager
Using AutoHotKey's powerful hotstring feature, MedMACROS lets you manage hotstring lists ("Dictionaries") in a convenient way.
This feature is useful for quickly writing any long, repetitive text, extending abbreviations, replacing eponyms, or replacing brand names with their corresponding generic denominations.
MedMACROS can also keep multiple hotstring sets and switch between them via the settings GUI.
### Quick text
When large chunks of text are required, the hotstrings feature may be too cumbersome.
The quick text feature lets you keep a library of text snippets that can be quickly inserted by calling the GUI and selecting a snippet from the list.
### Alternative pasting from clipboard
Some electronic medical record systems disallow pasting into text fields. This feature lets the user send text from the clipboard as keystrokes in order to circumvent restrictions.
### Login manager
Meant for quickly logging in to shared applications in a hospital network, like radiology, lab results and the like.
### File manager
This feature generates a hierarchic tree view from a preset folder. Useful for storing reference material or other files for quick access.
There's also a drag-and-drop feature that will copy the dropped files to the folder.
### Shortcuts
Lets you add shortcuts for commonly used applications or files. It uses Window's own .lnk files, therefore it's extremely flexible, letting the user add web shortcuts and even custom launch options on exectuables.
### Notepad
Small section for jotting down notes, to-do lists, and other things. Not meant as a text editor.
### Phonebook
Useful when you need to keep track of a lot of phone extensions.

## Planned functionality
### Browseable medical record
The user can keep a database of medical notes in order to work with them later or submit them when a more appropriate location when becomes available. Useful when the medical record system goes offline, etc. Currently notes can be saved and loaded, but can't be searched directly from the editor.
### Other features
Feel free to contribute or request any features you might find useful for your particular work environment.

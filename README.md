# medMACROS
Small and extensible helper app for quickly writing medical notes during consultation,  written in Autohotkey.
GUI is fully translatable.

## Current functionality
### Extensibility via plug-ins
medMacros extensions are specially formatted Autohotkey scripts that can be used for augmenting the main script's own capabilities.
Some examples of extensibility:
- Add new sections to the main GUI via tabs.
- Add new features to the text editor.
- Add new options to menus.
- Add new sets of hostrings via specially formatted "dictionaries".
- Add new global hotkeys with custom actions (for example, navigating cumbersome menus via automated keystroke sequences).

### Hotstring manager
Using Autohotkey's powerful hotstring feature, this script lets you quickly add or remove new hotstrings. Extremely useful for quickly writing any long, repetitive text, extending abbreviations, replacing eponyms, or replacing brand names with their corresponding generic denominations. Multiple sets of hotstrings can be managed via a dedicated GUI.
### Quick text
When the hotstrings feature is too inconvenient, the quick text GUI lets you keep a library of text snippets that can be quickly inserted by calling the GUI and selecting a file from a list.
### Alternative pasting from clipboard
Many electronic medical record systems do not let you paste text directly inside fields. This method lets you send the text from the clipboard as keystrokes in order to circumvent restrictions.
### Login manager
Meant for quickly logging in to shared applications in a hospital network, like radiology, lab results and the like.
### File manager
Lets the user view a folder as a small treeview that can always be accesed, useful for quickly launching commonly used files.
### Shortcuts
Lets you add shortcuts for commonly used applications. Uses Window's own .lnk files, therefore it's extremely flexible, letting the user add web shortcuts and even custom launch options on exectuables.
### Notepad
Small section for jotting down notes, to-do lists, et cetera.
### Phonebook
Useful when you need to keep track of a lot of phone extensions.

## Planned functionality
### Browseable medical record
The user can keep a database of medical notes in order to work with them later or submit them to a more suitable location when it becomes available. Useful when the medical record system goes offline, etc.

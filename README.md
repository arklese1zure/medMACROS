# medMACROS
Small and extensible helper app for quickly writing medical notes during consultation,  written in Autohotkey.
GUI is fully translatable.

## Current functionality
### Extensibility via plug-ins
medMacros extensions are specially formatted Autohotkey scripts that can be used for augmenting the script's own capabilities, or adding macros for many other tasks, like quickly navigating complicated menu structures in electronic medical record applications, in order to save time taking notes, filling forms, and many others.
### Hotstring manager
Using Autohotkey's powerful hotstring feature, this script lets you quickly add or remove new hotstrings. Extremely useful for quickly writing any long, repetitive text, extending abbreviations, replacing eponyms, or replacing brand names with their corresponding generic denominations.
### Quick text
When the hotstrings feature is too inconvenient, the quick text GUI lets you keep a library of text snippets that can be quickly inserted by calling the GUI and selecting a file from a list.
### Alternative pasting from clipboard
Many electronic medical record systems do not let you paste text directly in the fields. This method lets you send the text from the keyboard as keystrokes in order to circumvent these restrictions.
### Login manager
Meant for quickly logging in to shared applications in a hospital network, like radiology or lab results. Not recommended for secure applications.
### File manager
Lets the user view a folder as a small treeview that can always be accesed, useful for quickly launching commonly used files.
### Shortcuts
Lets you add shortcuts for commonly used applications. Uses Window's own .lnk files, therefore it's extremely flexible, letting the user add web shortcuts and even custom launch options on exectuables.
### Notepad
Small section for jotting down notes, to-do lists, et cetera.
### Phonebook
Useful when you need to keep track of a lot of phone extensions.

##Planned functionality
###Browseable medical record
The user can keep a database of medical notes in order to work with them later or submit them to a more suitable location when it becomes available. Useful when the medical record system goes offline, etc.

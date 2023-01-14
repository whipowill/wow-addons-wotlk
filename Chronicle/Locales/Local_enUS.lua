-- Default locals
local L = LibStub('AceLocale-3.0'):NewLocale('Chronicle', 'enUS', true)

if not L then return end -- abort if not using these locals

L.Header = '|cff67b1e9C|cff4779cehronicle|r - %s' -- Chronicle with a colour changed C followed by a string filled in by the note title
L.Title = 'Title:'
L.Chronicle = 'Chronicle'
L.ChroniclePage = '|cff67b1e9C|cff4779cehronicle|r - Tome holds 1 page.'
L.ChroniclePages = '|cff67b1e9C|cff4779cehronicle|r - Tome holds %d pages.'


L.SlashChronicle = 'Use /chronicle or /journal to open/close the Chronicle window.'

L.NewPage = 'New Page'
L.NewPageDesc = 'Create a new page in your Chronicle.\n\nThis will save any changes to the current page.'

L.SavePage = 'Save Current Page'
L.SavePageDesc = 'Save changes to the current page. This is only a \'soft\' save and changes will be lost if WoW crahes before your next logout or UI reload.\n\nTo force a UI reload and \'hard\' save your changes to disk, hold down |cffffd100CTRL|r when saving.\n\nA UI reload is not recommended in combat as it can freeze your game for several seconds.'

L.Undo = 'Undo Changes'
L.UndoDesc = 'Undo any changes made to the current page since you last saved. This cannot be undone.'

L.DeletePage = 'Delete Page'
L.DeletePageDesc = 'Delete the current page from your Chronicle. This cannot be undone.\n\nYou must hold |cffffd100CTRL|r when deleting to confirm the deletion.'
L.UnableToDelete = 'Unable to delete the starting page.'

L.RunPage = 'Run Page As Script'
L.RunPageDesc = 'Execute the contents of the current page as an LUA script.\n\nTo avoid accidental execution, you must hold down both the |cffffd100CTRL|r and |cffffd100ALT|r keys to confirm.'

L.OpenIndex = 'Open Index'
L.OpenIndexDesc = 'Open the Chronicle index with a sortable list of all current notes.\n\nNote: If you navigate away from the current page via the index, all changes made to the current page will be saved.'

L.ChangeFont = 'Change Page Font'
L.ChangeFontDesc = 'Cycle through the font choices available for the text in your pages.\n\nThis setting applies to all pages.'

L.ChangeColour = 'Change Page Text Colour'
L.ChangeColourDesc  = 'Display a colour picker to choose a colour for the text displayed in your pages.\n\nThis setting applies to all pages.'

L.WelcomeToChronicle = 'Welcome to Chronicle'
L.WelcomeToChronicleLong = 'Welcome to Chronicle.\n\nChronicle is an in-game notepad with support for chatlinks, running LUA scripts and a fully sortable index.\n\nPlease note that all pages (and thus all changes) are global across all characters on an account.'

L.PageMetadata = 'Current Page Metadata'

L.Created = 'Created On:'
L.Author = 'Author:'
L.LastEdited = 'Last Edited On:'
L.EditedBy = 'Last Edited By:'
L.LetterCount = 'Letter Count:'

L.SortTitle = 'Title'
L.SortCreated = 'Creation Date'
L.SortAuthor = 'Author'
L.SortEdited = 'Last Edit Date'
L.SortEditedBy = 'Last Edited By'

# <i>Suikoden II/Genso Suikoden II</i> Bug Fix Patch
This patch fixes numerous bugs that are present in retail versions of <i>Suikoden II</i>.  Including game-breaking bugs, audio issues, and various frustrating glitches.  All patches are optional (unless they are requirements for patches you might choose to apply), so you can fix the recipes bug without fixing the Matilda Glitch if you like.
## Requirements
1. A disc image of the original game in your preferred language*.  Files with .bin, .img, and .iso extensions may be supported, but the image must be plain with no additional headers or other changes that certain rippers or compression tools might introduce.  When in doubt, try to convert the image to a standard ISO image first.
2. A copy of this patch.
3. About 1 GB of total storage space.

**Currently only the North American (US/Canada), Japanese, European English, Spanish, and German versions may be patched.  Source code is available for partial French and Italian patches, but you will have to build the patch files yourself and alter the patch script to apply them.**
## Applying
1. Run <i>gs2patcher.bat</i> to launch the patch dialog.  The message indicating an error loading lua-interface.lua can be ignored.
2. Choose the version of the game you want to patch from the drop-down list
3. Use the browse button by "Original Image" to select your original copy of the game.
4. Use the browse button by "Patched Image" to select a location for your patched file.  The process will not allow you to patch directly to the original, it must create a copy.  If you just want the copy to be the original name plus " patched" or something like that, the easiest way to browse again to your original file, select it, and then change the name within the "Save File..." dialog.  You should also not create your patch file in any of the bug fix patch's folders.
5. Select the patches you wish to apply by highlighting them in the list and then clicking the appropriate arrow button.  You can see a brief description of the patch by highlighting it.<p>By default, all bugs are fixed and the most common options are chosen for bugs with multiple fix options, e.g. the Kindness Rune which has a fix that causes a penalty to attack when the value is negative, or a fix that merely gives no bonus at all.
6. Some patches you select may exclude or require others, these will be activated or deactivated automatically as needed.
7. When you are satisfied with your selections, click "Apply Patch" and wait for the process to finish.  A progress bar will show changes periodically, but some hefty patches (such as the audio fix for the NA version) can run for a long time, and may cause the patch dialog to stop responding.  This is normal.
8. The patcher will notify you of success or failure.  A log file will be created in the same directory as gs2patcher.bat and should be provided if you need support.

## Notes
A few people have complained that their PPF utilities cannot apply the PPF files in the patch folders.  This is by design.  The usual PPF format lacks certain features (mostly the ability to append to files instead of just replacing), and it relies on 64-bit integers for file offsets.  The Lua utility this patcher uses to read the disc image has no native support for integers beyond 32-bit.  It was far easier to implement a custom version of PPF with the required features, that only used 32-bit offsets, than it would have been to use standard PPF and work around the limitations.

Beyond all that, the patch files are not meant to be applied to the disc image directly.  All the offsets are specific to given files, and some patches require more than one PPF and that more than one target file be modified.  If standard PPF was used, manually patching with another utility would still require that the contents of the disc be ripped to your device's file system so that individual game files could be patched.  Then the image would have to be rebuilt in the proper order, and all Logical Block Address listings stored in the game files would have to be updated, if even a single file size/location changed.  There are something like 60 copies of the LBA listing.  The patcher does all this for you.

One possible solution if you can't use this patcher on your device, is to have someone else create a PPF for you.  At present, the patching only resizes individual files when required.  The disc image itself has several sectors of padding at the end, and the utility takes care to pad the output image to the same length as the original image.  If there are, say 50 sectors of padding in the original, and patching uses an extra 2 sectors for data, the output will have 48 sectors of padding.  The output image, therefore, is the same size as the original.  What this means is that standard PPFs can be made after using this utility to apply selected patches.  Just use the original image, the patched result, and any standard PPF suite to create one.  The resulting PPF will likely be quite large, especially for the US/NA version, but it could be applied cross-platform.  Provided a PPF utility for the platform exists.

## Patches Provided by Current Release

### Armor Effects/Bonuses Fix
Fixes a few issues that caused armor bonuses to be applied incorrectly.  In particular, the Master Robe was given Earth Armor's resistance to negative statuses, and the magic repelling effect that should belong to the Robe of Mist.

### Badeaux Appears
Fixes a script so that Badeaux will appear in your castle after being recruited.

### Castle Armory Fix
Changes the behaviour of the Castle Armory menus to fix the potch bug.  Without this fix, the Armory can be exploited for essentially infinite money.

### Castle Farm Fix
Fixes the castle farm module so that when multiple seeds or animals are turned into the NPCs at one time, the appropriate number will appear in your farm instead of just one.

### Chaco Bug Fix
Adds a missing script command to set Chaco's level.  At one point in his recruit event it was possible for him to join at level 1.

### Circlet Name Correction
Changes the item name of "Circuret" to "Circlet".

### Collectibles Fix
Fixes the after battle module so that its searches for handed-in collectible items will work (Books, Plans, Recipes, Sound Sets and Window Sets).  Normally, if the item has been given to the NPC, e.g. Hai Yo, the search will work improperly and retrieve incorrect results.  This can lead to the player acquiring multiple copies or it may become impossible to acquire the items at all (Recipe #34).

### Forgiver Sign Fix
Repairs a cosmetic issue where Forgiver Sign would appear to cause strangely massive amounts of damage to an enemy or to heal it, if your party required more than the allotted amount of healing.  Forgiver Sign uses an HP pool of about 2000 to heal your party and whatever is left is then damage to a selected enemy.  If the pool was exhausted by healing your party, the game would not update the buffer used when displaying the damage amount on screen, so whatever garbage was already there was used.  The enemy's HP does not actually change.

### Gozz Rune Name Fixes
Will change the name of the Gozz Rune to either "Gozu" (more appropriate if you are familiar with Japanese myths) or "Minotaur" (for Westerners).

### GS1 Load - Names Fix
Corrects the re-encoding of names so that your hero from Suikoden will have the name you gave him.  It also fixes the import of the Castle name from the original game, but that can only be seen in one Old Book.

### GS1 Load - Rune Import
Changes the Rune Import from Suikoden.  The original requires the character have all three rune slots empty, which limits the field to five characters, and then does some garbled checks that will never actually work before actually applying the runes.  Removed the garbled checks, and changed the logic to be simply that the character has an open rune slot, and the slot is unlocked at their current level (including bonuses from earlier in the import).  Check the Suikosource.com guide for a list of runes that may be transferred.  The short list is first-tier spell runes like Fire, and attack runes with a small benefit like Double-Beat and Counter.

### GS1 Load - Tai Ho
Swaps Vincent, who was unplayable in Suikoden, for Tai Ho, with a default level of 27.  This gives him the same level bonus opportunities as Hix, Luc, and Tengaar, with a maximum level of 47 if he is 99 in your Suikoden save and wins the +5 bonus for highest level.  His weapon can be as high as level 10.  With the Rune Import patch, he will still not be able to transfer runes.  He never gets a second slot, and he starts with a Killer Rune affixed to his lone slot in Suikoden 2.

### Inns Fix
Prevents inns from healing you for free.

### Join At 99 Fix
Fixes an intermittent issue that could cause characters who join with a level based on another character's to incorrectly become level 99.

### Kindness Rune Fixes
Alters the ATK calculation so that when the Kindness level of a character becomes negative, they don't receive 999 ATK.  There are two varieties of this fix.  The "Penalty" version will apply a penalty to ATK if the Kindness rating becomes negative.  I believe this was the intent of the developers.  The "No Penalty" version simply sets the bonus to zero.  In either version, the negative Kindness rating must be worked off before the character will receive a proper bonus again.

### Knife-thrower Fix
During the show in Ryube, Eilie can hit the hero with a thrown knife, inflicting 1/2 max HP as damage.  This can cause the hero to have 0 HP out of battle.  The fix ensures that 1 HP will always remain.

### Lamb Fix
Yuzu's last lost lamb and one of the chests in the Unicorn Woods shared a status flag, so getting one would make it impossible to get the other.  Shifts the lamb to another flag.

### Luca Battle Party-change Fix
Prior to fightin Luca, your team is emptied and then you must choose three parties of up to 6 to fight him.  When this occurs, the hero's party is not reordered as it should be, which can allow you to create a party with him alone in the back row where Luca cannot attack him.  The fix forces the party to be reordered.

### Matilda Gate Fix
Makes the Matilda Gate a fixed object so that it cannot be pushed out of the way during the early phases of the game.

### Music Fixes (NA only)
Repairs the audio data encoded on the disc so that all songs and sound effects will play.  Only required in the US/Canada version.  The issue was not present in Japan, and was fixed for Europe.

### Rune Speed Fix (Currently NA Only; Beta)
When Rune Unites are used, they replace data indicating what Rune and spell were used.  A routine that checks if the spell grants a temporary speed boost (in general healing spells give 1.3x speed when executed) will use this data as if it was Rune + Spell, and can retrieve garbage data.  Sometimes this causes Unites to get a speed boost when they shouldn't.  Fixes the routine to not bother looking when a Unite has been inserted into the data.

### Rune Unite Fix
The game continues to search for Unite partners after one has been discovered, and replaces or cancels actions as required.  This could result in up to 5 Unites for a cost of 6 MP when only 3 or less should have occurred.  Or it can lead to one person casting a Unite while everyone else does nothing.  The fix stops the search after a single partner is located.

### Scroll Shop Display Fix
Fix the scroll shop so that it does not display the names of unidentified (un-appraised) items.

### Tenzan Pass Enemies Fix
Translate the names of the enemies that are encountered in Tenzan late in the game.  Also restores the Chimaera parties to the encounter list so you can fight them.

### Tinto Glitch Fix (Currently NA Only; Beta)
Fixes a scripting problem that would make it impossible to progress or to even leave Gustav's Manor when you are returned there after Jess orders his troops to attack Neclord.

### Trade Gossip Translation (NA Only)
Translate the Trade Gossip (UWASA text).  These lines of text were left untranslated in the US/Canada version only.

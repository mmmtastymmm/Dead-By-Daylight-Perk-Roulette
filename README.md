# Dead by Daylight Perk Picker

An app to randomly pick perks to spice up your builds or provide more of a challenge!

## Basic Usage

After picking a role (survivor is shown below) a default perk selection will be presented.

![An example survivor load out.](pictures/survivor_default.PNG)

Below is an explanation of the buttons:
* **Filter Perks** - This option, located at the top of the window, allows you to disable any perks that
you don't want to include in the random selection. Once disabled, these perks will not appear in future rotations.
* **Reroll** - rerolls all the perks.
*  **Include an Exhaustion Perk** - If this box is checked, at least one perk that interacts with the exhaustion status will be 
included in your loadout. This includes perks like _Made for This_, which only works if not 
exhausted, or _Sprint Burst_, which causes exhaustion
* **Include a Boon Perk** - Check this box to guarantee at least one boon perk in your loadout.

Under all perks is another set of buttons:
* **Reroll** - This button rerolls that individual perk. 
* **Disable** - Clicking this will both reroll and disable the current perk, ensuring it doesn't show 
up in future random selections.

Below is an example of the perk filter screen, with the lighter icons indicating they are enabled
and the darker icons indicating they are disabled. Currently, only _Autodidact_ is disabled. The top 
right button will turn all perks on or off again, as indicated when hovering over the button.

![The filter screen showing all perks enabled except for autodidact](pictures/survivor_filter_screen.PNG)

Below is an example with the checkboxes checked and both requirements satisfied (the exhaustion perk is
_Smash Hit_ and the boon perk is _Boon: Circle of Healing_).

![An example survivor load out with the conditional boxes checked.](pictures/survivor_checked_boxes.PNG)

The killer perk selection is similar, just instead of exhaustion and boon perks there are scourge 
hooks and hexes. 

![An example killer load out with the conditional boxes checked.](pictures/killer_checked_boxes.PNG)
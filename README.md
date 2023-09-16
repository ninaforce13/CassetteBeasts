# Assumptions and Notes
This guide assumes that you have already read through the [Developer's Modding Guide](https://wiki.cassettebeasts.com/wiki/Modding:Mod_Developer_Guide) and have completed the necessary pre-requisites to setting up your modding environment. 

Note that this guide will only be covering the basics of creating a monster sticker and getting it loaded into the move pool. It does not cover **move editing**, **archangel moves**, or creating **new move behaviors**. This guide will focus on using the available scripts and resources to put together something new, but familiar within the current mechanics of Cassette Beasts.

Any code shown below is code I wrote myself. I won't be sharing any specific code from the game, but I will point you to the necessary directories to find what you're looking for and show inspector panel screenshots to help clarify some instructions. 

# Setting up your Mods folder
Organization is key and we want to keep our new files where we can easily find them later should we need to make any changes. 

From here on we will be working within the Godot Editor:

1. In your FileSystem panel *(bottom left)* **create** a ```mods``` folder in your ```res://``` directory if you haven't already.
2. Create a new subfolder within the mods folder and give it your mod name *(For the purpose of this guide I'll name it StickerMod, but you can call it whatever you like)*
# Creating the Sticker
3. Right click your ```StickerMod``` folder and select ```New Resource```. In the popup, choose Resource and click create.
![resource creation](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/89807d9d-7fb5-4d45-a0cd-98c4a1948879)

4. The file name can be whatever you want, but we'll call it "DivealsNewGroove" for now.
5. Double click on your new ```DivealsNewGroove.tres``` file to see it in the Inspector Panel *(displayed on the right)*. In that Inspector panel, click the Script dropdown and choose quick load.
![inspectorwindow script assignment](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/0e5f6fb7-8b00-4874-865b-395792dd935b)

6. In the search bar, you can type ```battle_move_scripts``` to filter by the scripts located in the move scripts folder, these are the ones used by current battle moves and what we will be using to select our move's base behavior. For this guide we will use ```GenericAttack.gd```, however feel free to explore and experiment as you see fit afterwards.
![battle_move_scripts](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/6520568e-c740-465a-910c-ab5fabd23cef)

Note: 
There's a lot of scripts here that will cover just about whatever you're trying to do, if you're not sure what you want then look up a move you want to emulate and see what script it is using. These can be found in the ```res://data/battle_moves/``` directory.

# Setting up our Sticker Properties
7. Now that we've assigned our battle move script, the Inspector will change to show the available options we have for that specific battle move type. We'll cover some of these here, the rest you can experiment with as you get comfortable.
   
![Divealsnewgroove tres file](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/3dd0475f-59bf-4513-9578-b84cd245eb02) ![image](https://github.com/ninaforce13/CassetteBeasts-StickerModdingGuide/assets/68625676/1e463281-1f38-4142-b5e0-5a87ed107796)


   * **Name**(required) - Pretty self explanatory, this is the Display Name for your move.
   * **Category Name**(required) - This is the category your move falls under: Melee, Ranged, Misc, Status *(this is just for display purposes, the actual set up for this is in other attributes)*
   * **Description**(required) - The description for what your move does
   * **Tags**(required) - This is how we determine who can use this sticker. There's a lot of tags and while you could make up your own tag, if you have a specific monster you want to target with this sticker then you should use the tags for that monster. In this case we will assign the ```diveal``` and ```unsellable``` tags to our sticker to ensure this move is exclusive to the Diveal family. You could also assign the ```any``` tag if you intend your move to be compatible with any monster.
   * **Attribute Profile**(required) - This determines the available bonus stats that can be applied to this sticker during rarity upgrades. You will find them in ```res://data/sticker_attribute_profiles/```
   * **Cost** - How much AP your move will use
   * **Power** - The base damage of your move. 
   * **Physicality** - This determines if your move is Melee or Ranged. 
   * **Target Type** - This determines who is affected by your move: One Enemy, All Enemies, One Ally, All Allies, Everyone, etc.
   * **Default Target** - This is where the game will initially focus the target when selecting the move in battle.
   * **Elemental Types** - This determines the element used for the attack. You can find the existing elemental types in ```res://data/elemental_types/``` drag an elemental profile from there to assign to this attribute. Leaving it empty will assume it to be a typeless move that adjusts to the type of the user.
   * **Attack Vfx** - This is the visual effect shown when the monster uses this attack. This guide won't cover custom effects, but you can find the existing ones in ```res://data/attack_vfx/```. Just drag whichever one you want into this attribute.
   * **Hit Vfx** - This is the visual effect that shows on the monster being targeted by the move. You will find available effects in ```res://data/hit_vfx/```
   * **Target Status Effects** - If applicable, this is the status effect that your move will apply to targets. Usable status effects are found here ```res://data/status_effects/```. You could also write your own status effect scripts to be used, but we will not be covering that in this guide.
     * **Status Effects to Apply** - If you have more than one status effect assigned above, then you can use this to determine whether to apply them all or one at random *(like wonderful7)*
     * **Status Effect Amount** - You can adjust this number to be the number of turns the effect will be set for initially.
     * **Status Effect Chance** - This is the %chance your move will apply the effects, 0 being no chance at all and 100 being guaranteed to apply.

# Adding Sticker to Move Pool
8. Now that we've set up our new sticker, we need to get it into the move pool where we can access it in the game. Let's go back to our ```StickerMod``` folder and right click to create a ```New Script```. You can name it what you want, but we'll just call it ```load_sticker_mod```. This is the script we will use to manage loading our mod and seeding the new sticker into the move pool.
9. Feel free to copy the code below for this load_sticker_mod or edit it to suit your specific needs. I've left comments in the code to explain what's going on if you want to make adjustments. 
```
# ContentInfo is what we use to provide the metadata for our mod to the Game's mod loader.
extends ContentInfo

#This is where we load our sticker to be added into the movepool below. 
#Please use the exact directory where the sticker is located.
#Write one of these for each sticker you will be adding if you made multiple.
var sticker1 = preload("res://mods/StickerMod/DivealsNewGroove.tres")

func _init():
# Waits for the by_id table to load before adding the new move.
	while BattleMoves.by_id.size() == 0:
		yield(Co.wait(5),"completed")   
#  A call to our function for seeding the sticker. Call this once per each sticker you are adding.
	add_sticker(sticker1)
#	We're done! This is just so we know our mod loaded.
	print("Custom Stickers Loaded")

# This function is how we will seed the sticker into the movepool.
func add_sticker(sticker):
# Replace "stickernamehere" with a unique name for your sticker to make it usable with the debug console
	BattleMoves.by_id["stickernamehere"] = sticker
#	The primary sticker bucket. This will get used in certain Loot Tables, The Be Random attack, and part of AlephNull's movepool script.
	BattleMoves.all_stickers.append(sticker)
#	This is the important bit, here we added our sticker into the move pool by the tags we used. This way anyone that matches them will be able to learn them.
	for tag in sticker.tags:
#		A quick initializer for the tag since at this point there hasnt been any other stickers loaded yet.
		if not BattleMoves.by_tag.has(tag):
			BattleMoves.by_tag[tag] = []
#		Actually adding it to the pool.
		BattleMoves.by_tag[tag].push_back(sticker)
		if not BattleMoves.stickers_by_tag.has(tag):
			BattleMoves.stickers_by_tag[tag] = []
		BattleMoves.stickers_by_tag[tag].push_back(sticker)
#       If you've tagged your sticker with unsellable, then we won't place it in the move pool for shops.
		if not sticker.tags.has("unsellable"):
			BattleMoves.sellable_stickers.push_back(sticker)	
			if not BattleMoves.sellable_stickers_by_tag.has(tag):
				BattleMoves.sellable_stickers_by_tag[tag] = []
			BattleMoves.sellable_stickers_by_tag[tag].push_back(sticker)


```

# Mod Metadata
10. Now that the script is ready we'll need to create another ```Resource``` in our ```StickerMod``` folder. This time we will name it ```metadata``` **(note: this part is mandatory, you must name it metadata)**
11. Open the newly created ```metadata.tres``` in the Inspector Panel and let's assign our load_sticker_mod script to it. Now we can fill out the information as per the mod developer guide linked at the start of this guide. You shouldn't need to assign anything to Modified Files or Modified Directories as we're making everything new.
    
![metadata pic](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/c3fe5ad2-c231-4098-b130-7b91e2cbe2df)

13. Now you can use the Export Mod tool to pack up your new mod and use it in your game. *(This is covered in the Modding Guide linked above under the Exporting Your Mod section.)*
If you followed the guide correctly, you should see your mod loaded on the Title screen and the new moves will be learned naturally as the monster tape levels up.
![20230705102705_1](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/4138b4e3-49a0-420e-a4e1-b9e9813a5750)
![divealsnewgroove](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/d14eb851-ba05-4473-9a08-fe805e62e773)
![20230705120550_1](https://github.com/ninaforce13/CassetteBeasts/assets/68625676/99ad1d15-adc2-483b-8001-1bf6fee6ce0c)

# Closing Notes
A lot of this guide is focused on making stickers that fit into the game's current standards for stickers. There's a lot I didn't cover because it's either too specific (Archangels) or just plain out of scope (Fusion moves). 

There are places in this guide where you can diverge to create something far more customized, such as the battle_move_script assignment. You might have an idea for something that is **similar** to an existing move behavior, but with minor tweaks. In these cases you could copy the script for that behavior into your mod folder to make the necessary adjustments and then assign that new script to your new ```sticker resource```. The same applies to the creation of new status effects which isn't covered here, but is perfectly doable as well if you're needing something different as existing status moves also have their own behavior scripts assigned to them that you could copy to modify to your needs in this scenario. 

In regards to move tags, there's no one stop shop location for all of them. However, you can look at each monster form directly to see what move tags are applicable to that tape. This way you can be more specific with your sticker. 
 
The code shown above for the metadata script is written in a way that should allow for multiple modders to follow this guide and not overwrite each other. You don't have to use it exactly as is, that is just the specific implementation that worked for my testing. As always code is flexible and specific to your own needs so feel free to experiment.

When a mod like this is unloaded, the custom stickers will just dissappear. So it's perfectly safe to uninstall these kinds of mods since all that happens is they don't load in the stickers.

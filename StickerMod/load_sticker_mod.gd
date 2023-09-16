# ContentInfo is what we use to provide the metadata for our mod to the Game's mod loader.
extends ContentInfo

#This is where we load our sticker to be added into the movepool below. 
#Please use the exact directory where the sticker is located.
#Write one of these for each sticker you will be adding if you made multiple.
var sticker1 = preload("res://mods/StickerMod/DivealsNewGroove.tres")

func _init():
# Waits for by_id to be loaded before adding move so we can make it work in debug console
	while BattleMoves.by_id.size() == 0:
		yield(Co.wait(5),"completed")   
#  A call to our function for seeding the sticker. Call this once per each sticker you are adding.
	add_sticker(sticker1)
#	We're done! This is just so we know our mod loaded.
	print("Custom Stickers Loaded")

# This function is how we will seed the sticker into the movepool.
func add_sticker(sticker):
# Change the "stickernamehere" to a unique name for the sticker. This is what will be used in the debug console
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

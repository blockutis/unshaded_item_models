# Unshaded Item Models
### Made by Blockutis for 1.21.4 and 1.21.5

### Use this to create item models without shading, because item models don't actually respect the "shade" setting.
### NOTE: Only removes shading, items will still be affected by light level.
I initially created this because I wanted to make custom crops using item displays, but item models are shaded, unlike regular minecraft crops.
With this, you can create an item display that looks identical to an actual crop.

## TO USE: 
Paint a pixel with RGB value 252,10,240 on the top left of any 16x16 item texture. You can change this RGB value in the shader files.\
You can also alternatively enable using a certain alpha value for the texture instead, for example if you cannot put a pixel in the top left corner, or if the texture is not 16x16.\
Open `shaders/core/entity.fsh` and `shaders/core/rendertype_item_entity_translucent_cull.fsh` to see how it works, modify it, and optionally enable using alpha value detection.

### NOTE: `entity.fsh` affects only block-placing items, and `rendertype_item_entity_translucent_cull.fsh` affects only non-block-placing items.
Remember to **change both if you change one**, if you want all items to be affected the same way.

### Example items:
/give @p fern[custom_model_data={floats:[1]}]

/give @p glow_berries

/give @p glowstone_dust

### Item displays of example items:
/summon item_display ~ ~0.5 ~ {item:{id:"minecraft:fern",components:{"minecraft:custom_model_data":{floats:[1]}}}}

/summon item_display ~ ~0.5 ~ {item:{id:"minecraft:glow_berries"}}

/summon item_display ~ ~0.5 ~ {item:{id:"minecraft:glowstone_dust"}}

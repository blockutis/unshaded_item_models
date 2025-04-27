#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
	vec4 color = texture(Sampler0, texCoord0);
	// NOTE - THIS FILE ONLY AFFECTS BLOCK-PLACING ITEMS. NON-BLOCK PLACING ITEMS ARE AFFECTED BY RENDERTYPE_ITEM_ENTITY_TRANSLUCENT_CULL.FSH
	
	// Choose a "marker" color to mark any texture to be rendered without shading by painting the top left pixel of that texture with this color.
	// Default is 252,10,240. I chose an arbitrary color that is unlikely to be used normally.
	vec4 markerColor = vec4(252, 10, 240, 255);
	
	// Don't render a pixel with the RGB of the marker color
	if(color.rgb*255 == markerColor.rgb) discard;
	
#ifdef ALPHA_CUTOUT
	if (color.a < ALPHA_CUTOUT) {
		discard;
	}
#endif
	bool shade = true;
	// Using texCoord0 and texture size, find the pixel coordinates of the top left pixel in this texture (only works with 16x16 textures) (can be modified to work with other sizes)
	ivec2 tSize = textureSize(Sampler0, 0);
	ivec2 currentPixelCoord = ivec2(int((texCoord0.x) * (tSize.x)), int((texCoord0.y) * (tSize.y)));
	ivec2 topLeftCoord = ivec2(int(floor(currentPixelCoord.x/16) * 16), int(floor(currentPixelCoord.y/16) * 16));
	
	// If the color at that top left pixel has the marker color's RGB, then the entire texture will be rendered without shading.
	// If not, then it will render with shading as usual.
	vec4 topLeftPixel = texelFetch(Sampler0, topLeftCoord, 0);
	topLeftPixel.rgb *= 255;
	if(topLeftPixel.rgb == markerColor.rgb){
		shade = false;
	}
	
	// ALTERNATIVE - DETECT USING ALPHA VALUE
	// Use a specific alpha value on each pixel to specify that it should not be shaded
	// The reason this is not enabled by default is because I use VanillaDynamicEmissives by ShockMicro in my own resourcepack,
	// which uses alpha value to detect pixels that should be emissive, and have reserved many different alpha values for that.
	// If you don't use that, or if you specify different alpha values here than those for VanillaDynamicEmissives, it should be fine.
	
	// Uncomment the section below to enable.
	// 253 can be changed to any number you prefer, but some alpha values are used normally in-game, so be careful.
	/*
	int alpha = int(round(textureLod(Sampler0, texCoord0, 0.0).a * 255.0));
	if(alpha == 253){
		shade = false;
	}
	*/
	
	
	if(shade == false){
		color *= ColorModulator;
	}else{
		color *= vertexColor * ColorModulator;
	}
	
#ifndef NO_OVERLAY
	color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
	color *= lightMapColor;
#endif
	fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}

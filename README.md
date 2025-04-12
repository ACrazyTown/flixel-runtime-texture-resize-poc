# HaxeFlixel Runtime Texture Resize (Proof of Concept)

A proof of concept showcasing runtime texture resizing (while retaining original sprite size) in HaxeFlixel.

This allows us to resize a sprite's texture, while still keeping the sprite's width and height the same. This is useful in cases where the texture upload limit on the device running the game is lower than our texture's size (eg. mobile phone or lower-end computer).

![showcase.gif](showcase.gif)

## TODO
- [ ] Make this work without a custom shader
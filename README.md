# BashNN
### Example of a neural network writed on bash
Its main purpose is to distinguish two different image types, like faces - no faces, etc.

Better source image resolution - better but slower learning.

To change the source model resolution, change number of steps in `blankmodel()` function to match the resolution multiplication, so **4096** for **64x64** as example.

Add the blankmodel function to `main()` to create the initial model, then remove to continue training.

Currently it will take `.jpg` images as **negative** examples and `.png` for **positive** to automate the training process, but you can uncomment and comment the `check()` function to match your needs.

Use `./evaluator.sh image.png` to test with trained model

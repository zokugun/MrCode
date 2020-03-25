#!/bin/bash

for file in vscodium/vscode/resources/darwin/*
do
	if [ -f "$file" ]; then
		name=$(basename $file '.icns')

		if [[ $name != 'code' ]] && [ ! -f "src/src/resources/darwin/$name.icns" ]; then
			icns2png -x -s 512x512 $file -o .

			composite -blend 100% -geometry +323+365 icons/corner_512.png "${name}_512x512x32.png" "$name.png"
			composite -geometry +338+365 icons/code_138.png "$name.png" "$name.png"

			convert "$name.png" -resize 256x256 "${name}_256.png"

			png2icns "src/src/resources/darwin/$name.icns" "$name.png" "${name}_256.png"

			rm "${name}_512x512x32.png" "$name.png" "${name}_256.png"
		fi
	fi
done

if [ ! -f "src/src/resources/darwin/code.icns" ]; then
	convert src/src/resources/linux/code.png -resize 512x512 code_512.png
	convert src/src/resources/linux/code.png -resize 256x256 code_256.png
	convert src/src/resources/linux/code.png -resize 128x128 code_128.png

	png2icns src/src/resources/darwin/code.icns code_512.png code_256.png code_128.png

	rm code_512.png code_256.png code_128.png
fi

for file in vscodium/vscode/resources/win32/*.ico
do
	if [ -f "$file" ]; then
		name=$(basename $file '.ico')

		if [[ $name != 'code' ]] && [ ! -f "src/src/resources/win32/$name.ico" ]; then
			icotool -x -w 256 $file

			composite -geometry +152+187 icons/code_64.png "${name}_9_256x256x32.png" "${name}.png"

			convert "${name}.png" -define icon:auto-resize=256,128,96,64,48,32,24,20,16 "src/src/resources/win32/$name.ico"

			rm "${name}_9_256x256x32.png" "${name}.png"
		fi
	fi
done
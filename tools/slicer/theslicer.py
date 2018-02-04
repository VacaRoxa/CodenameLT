#!/usr/bin/python3
# -*- coding: utf-8 -*-
from PIL import Image
import os.path
import json

base_img_width = 192
base_img_height = 192

def make_sprite_img(im, x,y, width, height):
    box = (x, y, x+width, y+height)
    output_img = Image.new('RGBA', (base_img_width, base_img_height), (0, 0, 0, 0))
    a = im.crop(box)
    output_img.paste(a,(int(base_img_width/2-a.size[0]/2),int(base_img_height/2-a.size[1]/2)))
    return output_img


def theslicer(Path, jsonfile, input):
    im = Image.open(input)

   
    json_file = open(jsonfile)
    json_str = json_file.read()
    json_data = json.loads(json_str)

    print(json_data)

    slices = json_data['meta']['slices']

    k = 0
    sprites_imgs = []
    for slice in slices:
      k = k + 1
      print('')
      print(slice)

      t_x = slice['keys'][0]['bounds']['x']
      t_y = slice['keys'][0]['bounds']['y']
      t_w = slice['keys'][0]['bounds']['w']
      t_h = slice['keys'][0]['bounds']['h']
      t_name = slice['name']
      sprite_to_save = make_sprite_img(im,t_x,t_y,t_w,t_h)
      sprites_imgs.append(sprite_to_save)

    output_img = Image.new('RGBA', (base_img_width*len(sprites_imgs), base_img_height), (0, 0, 0, 0))

    j=0
    for i in sprites_imgs:
      
      output_img.paste(i,(j*base_img_width,0))
      j=j+1


      
    output_img.save(os.path.join(Path, "tileset.png"))
           


            
#theslicer("OUTPUT_FOLDER","atlas01.json","../../project/img/atlas01.png")
theslicer("OUTPUT_FOLDER","atlas01.json","atlas01-sheet.png")

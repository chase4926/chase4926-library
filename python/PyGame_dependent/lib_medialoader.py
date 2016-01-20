
"""
lib_medialoader.py
---
Load all the images, tilesets, and sounds in one place once.

This is inspired by my ruby library for libGosu that does the same thing.
"""

import os
import pygame

IMAGE_DICT = {}
PYGAME_IMAGE_EXTENSIONS = ('jpg', 'png', 'gif', 'bmp', 'pcx', 'tga', 'tif',
                           'lbm', 'pbm', 'pgm', 'ppm', 'xpm')

def load_images(path):
  for dirname, dirnames, filenames in os.walk(path):
    for filename in filenames:
      if filename.split(".", 1)[1].lower() in PYGAME_IMAGE_EXTENSIONS:
        filename = os.path.join(dirname, filename).replace("\\", "/")
        IMAGE_DICT[filename.split(path, 1)[1]] = pygame.image.load(filename)

def get(path):
  return IMAGE_DICT[path]


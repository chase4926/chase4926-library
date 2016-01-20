
"""
lib_misc.py

This is a miscellaneous collection of python functions.
"""

import math, random

def distance(x1, y1, x2, y2):
  return math.sqrt( ((float(x2) - float(x1)) ** 2) + ((float(y2) - float(y1)) ** 2) )

def offsetX(angle, radius):
  return math.sin((float(angle) / 180) * math.pi) * float(radius)

def offsetY(angle, radius):
  return -1 * math.cos((float(angle) / 180) * math.pi) * float(radius)

def getRandomGradient(length, minimum, maximum):
  result = length * [minimum]
  high_index = random.randint(0, length-1)
  for i in range(length):
    if i == high_index:
      # If it's the high point, give it the maximum
      percent = 1.0
    elif i < high_index:
      # If it's less than the high point, interpolate with respect to 0
      percent = float(i) / high_index
    else:
      # i > high_index:
      # If it's more than the high point, interpolate with respect to length-1
      percent = float((length - 1) - i) / ((length - 1) - high_index)
    result[i] = int(round(minimum + (percent * (maximum - minimum))))
  return result

def getRandomColor():
  return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))


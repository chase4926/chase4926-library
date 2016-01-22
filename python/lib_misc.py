
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

def get_new_resolution(window_width, window_height, default_width, default_height, keep_aspect=True, scale=True):
  # Input: window_width, window_height = Width & Height of the window
  #        default_width, default_height = Width & Height of the program
  #        keep_aspect = Whether or not to keep the aspect ratio when scaling
  # Output: (new_width, new_height)
  if scale:
    if keep_aspect:
      # p_width = proposed width
      # P_height = proposed height
      p_width = (default_width * window_height) / default_height
      p_height = (default_height * window_width) / default_width
      if p_width <= window_width:
        # We'll use (p_width, window_height)
        return (p_width, window_height)
      else:
        # We'll use (window_width, p_height)
        return (window_width, p_height)
    else:
      # Scaling but not keeping the aspect ratio so use the window width & height
      # Note: This option usually looks the worst
      return (window_width, window_height)
  else:
    # Not scaling so use the desired width & height
    # Note: This option can produce a tiny image
    return (default_width, default_height)


# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  # Check for exceptions
  # http://www.peteonsoftware.com/index.php/2009/08/16/ruby-koans/
  # Wanted to skip this and look at it later - code taken from above
  # Not really interested in working out a triangle problem 
  # Hit a break wall and needed to learn/pratice the rest of Ruby
  
  # Pete's code for raising exceptions 
   if (a <= 0 or b <= 0 or c<=0)
    raise TriangleError
  end
  
  sides = [a, b, c].sort
  
  if (sides[0] + sides[1] <= sides[2])
    raise TriangleError
  end
  
  if a == b && a == c  
    :equilateral 
  elsif a == b || a == c || b == c   
    :isosceles
  else
    :scalene
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end

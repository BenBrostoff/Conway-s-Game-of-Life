require 'colorize'

class Cell

  attr_accessor :x, :y, :alive

  def initialize(x, y, alive = false)
    @x = x
    @y = y
    @alive = alive
  end

  def rule_impose(set_iter)
    if @alive == false
      @alive = true if alive_neighbor_count(set_iter) == 3
    else
      @alive = false if alive_neighbor_count(set_iter) < 2
      @alive = true if (alive_neighbor_count(set_iter) == 2 || 
                                        alive_neighbor_count(set_iter) == 3)

      @alive = false if alive_neighbor_count(set_iter) > 3
    end
  end

  def neighbor_find
    neighbor_array = []
    (-1.. 1).to_a.each do |x|
      (-1.. 1).to_a.each do |y|
        neighbor_array << [@x + x, @y + y] unless x == 0 && y == 0
      end
    end
    neighbor_array
  end

  def alive_neighbor_count(set_iter)
    (set_iter & self.neighbor_find).size
  end

end 

class Board

  attr_accessor :cells, :grid_size, :size_x, :size_y

  def initialize(cells, x, y)
    @cells = cells
    @size_x = x
    @size_y = y
  end

  def all_alive
    hold = []
    @cells.each { |cell| hold << [cell.x, cell.y] if cell.alive == true }
    return hold
  end

  def mass_out
    set_iter = self.all_alive
    @cells.each do |cell|
      cell.rule_impose(set_iter)
    end
  end

  def play(type = "in_progress", alive_color = :red, dead_color = :blue)
    if type != "in_progress"
      m = method(type)
      m.call
    end

    system('clear')
    display(alive_color, dead_color)
    sleep(0.1)
    mass_out
    play(type = "in_progress", alive_color, dead_color)
  end

  def display(alive_color, dead_color)
    @cells.each_with_index do |cell, index|
      print "X".colorize(alive_color) if cell.alive
      print "O".colorize(dead_color) if !cell.alive
      puts "" if (index + 1) % @size_x  == 0
    end
  end

end

def generate_cells(size_x, size_y)
  hold = []
  size_y.times do |y|
    size_x.times do |x|
      hold << Cell.new(x, y) 
    end
  end
  return hold
end


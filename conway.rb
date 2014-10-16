require 'colorize'

class Cell

  attr_accessor :x, :y, :alive

  def initialize(x, y, alive = false)
    @x = x
    @y = y
    @alive = alive
  end

  def rule_impose(board, set_iter)
    @alive = false if alive_neighbor_count(board, set_iter) < 2
    @alive = true if @alive == true && (alive_neighbor_count(board, set_iter) == 2 || 
                                        alive_neighbor_count(board, set_iter) == 3)
    @alive = true if @alive == false && alive_neighbor_count(board, set_iter) == 3
    @alive = false if alive_neighbor_count(board, set_iter) > 3
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

  def alive_neighbor_count(board, set_iter)
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
    @cells.each { |cell| hold << [cell.x, cell.y] if cell.alive }
    return hold
  end

  def mass_out
    set_iter = self.all_alive
    @cells.each do |cell|
      cell.rule_impose(self, set_iter)
    end
  end

  def play(type = "in_progress", alive_color = :red, dead_color = :blue)
    if type != "in_progress"
      m = method(type)
      m.call
    end

    system('clear')
    display(alive_color, dead_color)
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

  def glider
    print @size_x.class
    (0.. 2).to_a.each do |x|
      @cells[x + @size_x * 2].alive = true 
      @cells[x + @size_x].alive = true if x == 2
      @cells[x].alive = true if x == 1
    end
  end

end

def generate_cells(size_x, size_y)
  hold = []
  size_x.times do |x|
    size_y.times do |y|
      hold << Cell.new(x, y) 
    end
  end
  return hold
end

start = Board.new(generate_cells(25, 25), 25, 25)
start.play("glider")
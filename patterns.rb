require_relative 'conway'
require_relative 'starting_uni'
require 'pry'

class Board

  def gun
    COORDS.each do |coord|
      @cells[(coord[0] + coord[1] * @size_x)].alive = true 
    end
  end

end

start = Board.new(generate_cells(36, 19), 36, 19)
start.play("gun", :green, :black)


class MazeSolver 
  attr_accessor :maze, :traveled_path, :visited_nodes, :node_queue

  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
  end

  def maze_array
    @maze_array_fixture = [[]]
    count = 0
    @maze.split("").each do |char|
      if char == "\n"
        @maze_array_fixture << []
        count += 1
      else
        @maze_array_fixture[count] << char
      end
    end
    @maze_array_fixture.pop
    @maze_array_fixture 
  end

  def x_dimensions
    self.maze_array[0].size
  end

  def y_dimensions
    self.maze_array.size
  end

  def start_coordinates
    self.maze_array.each do |row|
      row.each do |tile|
        if tile == "→"
          @start = [row.index(tile),self.maze_array.index(row)]
        end
      end
    end
    @start
  end

  def end_coordinates
    self.maze_array.each do |row|
      row.each do |tile|
        if tile == "@"
          @end = [row.index(tile),self.maze_array.index(row)]
        end
      end
    end
    @end
  end

  def node_value(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    if self.maze_array[y] && self.maze_array[y][x] 
      self.maze_array[y][x] 
    else
      nil
    end
  end

  def valid_node?(coordinates)
    node_value(coordinates) != "#" && node_value(coordinates) != nil
  end

  def neighbors(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    neighbors = [[x+1,y],[x-1,y],[x,y+1],[x,y-1]]
    neighbors.select do |neighbor|
      valid_node?(neighbor)
    end
  end

  def add_to_queues(current_tile, last_tile=self.start_coordinates)
    @traveled_path << [current_tile,last_tile] 
    @visited_nodes << current_tile 
    @node_queue << current_tile
    neighbors(current_tile).each do |neighbor|
      @node_queue << neighbor if neighbor!= last_tile
    end
  end

  def move
    until @node_queue.shift == self.end_coordinates
      last_tile = @visited_nodes.last
      current_tile = @node_queue.shift
      until !@visited_nodes.include?(current_tile)
        if @node_queue.empty?
          return @traveled_path
        else
          current_tile = @node_queue.shift
        end
      end
      add_to_queues(current_tile, last_tile)
    end
    # @traveled_path.each do |coords|
    #   print coords
    # end
    @traveled_path
  end

  def solve
    add_to_queues(self.start_coordinates)
    self.move
  end

  def solution_path
    self.solve
  end

  def display_solution_path
    @traveled_path.each do |coords|
      x = coords[0][0]
      y = coords[0][1]
      @maze_array_fixture[y][x] = "."
    end
    @string = ""
    @maze_array_fixture.each do |row|
      row.each do |tile|
        @string << tile
      end
      @string << "\n"
    end
    puts @string
  end
end
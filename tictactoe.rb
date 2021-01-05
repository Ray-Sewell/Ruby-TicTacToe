WINNING_POSITIONS = [
    [0, 1, 2], [10, 11, 12], [20, 21, 22],
    [0, 10, 20], [1, 11, 21], [2, 12, 22],
    [0, 11, 22], [2, 11, 20]
]

class Board
    attr_reader :board_matrix, :gamestate
    def initialize()
        @board_matrix = [
            [" "," "," "],
            [" "," "," "],
            [" "," "," "]
        ]
        @gamestate = :init
        @turns = 0
    end
    def print()
        puts; puts "0 1 2"
        @board_matrix.each_with_index{|line, index| puts line.join(" ") + " " + index.to_s}; puts
    end
    def check(x, y, token)
        if @board_matrix[y][x] == " "
            @board_matrix[y][x] = token
            @turns += 1
            return true
        else
            return false
        end
    end
    def check_gamestate()
        token_positions = {
            X: [],
            O: []
        }
        @board_matrix.each_with_index{|line, index|
        line.each_with_index{|token, position| if @board_matrix[index][position] != " "
        token_positions[(@board_matrix[index][position].to_sym)].push((index.to_s + position.to_s).to_i) end}}
        WINNING_POSITIONS.each{|position| if (position - token_positions[:X]).empty? 
        puts "X wins!"; @gamestate = :end; return end}
        WINNING_POSITIONS.each{|position| if (position - token_positions[:O]).empty? 
        puts "O wins!"; @gamestate = :end; return end}
        if @turns >= 9
            @gamestate = :end
            return "yee"
        end
        case @gamestate
        when :init
            @gamestate = :player1
        when :player1
            @gamestate = :player2
        when :player2
            @gamestate = :player1
        end
    end
end

class Player
    attr_reader :name, :token
    def initialize(name="Default", token)
        @name = name
        @token = token
    end
    def turn(board)
        puts "Please input an x coordinate following the map!"; puts
        x = nil; y = nil
        while x.nil?
            if (input = gets.chomp.to_i).between?(0,2)
                x = input
                puts; puts "Great, now input a y coordinate!"; puts
                while y.nil?
                    if (input = gets.chomp.to_i).between?(0,2)
                        y = input
                        if board.check(x, y, @token)
                        else
                            puts; puts "Sorry, that space is taken!"; puts
                            turn(board)
                        end
                    else
                        puts; puts "#{input} is not a valid y coordinate!"; puts
                    end
                end
            else
                puts; puts "#{input} is not a valid x coordinate!"; puts
            end
        end
    end
end

class AI < Player
    def turn(board)
        until board.check(x = rand(3), y = rand(3), @token)
        end
    end
end

def Menu
    puts "To start a game type start. For assistance type help. To exit type exit."; puts
    state = :on
    while(state == :on)
        case input = gets.chomp
        when "help"
            puts; puts "Type start to begin a game with a simple AI"
            puts "     exit to close this program"; puts
        when "start"
            board = Board.new()
            Game(board)
        when "exit"
            puts; puts "Goodbye!"
            state = :off
        else
            puts; puts "#{input} is not a valid command, for help type help!"; puts
        end
    end
end

def Game(board)
    state = :on
    while(state == :on)
        case board.gamestate
        when :init
            puts; puts "Hello human! What is your name?"; puts
            input = gets.chomp
            user = Player.new(input, "X")
            ai = AI.new("O")
            puts; puts "#{user.name} you are up against #{ai.name}!"
            board.print()
            board.check_gamestate()
        when :player1
            puts "It is your turn #{user.name}!"
            user.turn(board)
            board.print()
            board.check_gamestate()
        when :player2
            ai.turn(board)
            board.print()
            board.check_gamestate()
        when :end
            puts "Gameover!"; puts
            puts "To start a game type start. For assistance type help. To exit type exit."; puts
            state = :off
        else
            "error"
        end
    end
end

Menu()
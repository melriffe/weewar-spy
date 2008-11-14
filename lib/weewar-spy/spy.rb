module WeewarSpy
  
  class Spy
    attr_reader :director, :username

    def initialize(params)
      @username = params[:username]
      WeewarSpy::API.init(params)
      @director = WeewarSpy::Director.new(@username)
    end

    def infiltrate(game_id)
      Game.infiltrate(game_id)
    end
    
    def reconnoiter(game_id)
      Game.reconnoiter(game_id)
    end
    
    def shadow(username_or_id)
      WeewarSpy::User.new(username_or_id)
    end
    
    def debrief(game)
      puts "Official Debrief: #{game.name}"
      puts "----------------------------------------"
      puts game.basic_info
      game.players.each do |player|
        puts "--------------------"
        puts player.basic_info
        puts "\t" + player.troop_info
        ext_info = player.extended_troop_info
        unless ext_info.empty?
          puts "\t~~~~~~~~~~~~~~~~~~~~"
          puts "\tExtended Troop Info:"
          puts ext_info
          puts "\t~~~~~~~~~~~~~~~~~~~~"
        end
        puts "\t" + player.terrain_info
        ext_info = player.extended_terrain_info
        unless ext_info.empty?
          puts "\t~~~~~~~~~~~~~~~~~~~~"
          puts "\tExtended Terrain Info:"
          puts ext_info
          puts "\t~~~~~~~~~~~~~~~~~~~~"
        end
        puts "\t" + player.salary_info
      end
      puts "----------------------------------------"
      puts "For Director #{director.name.capitalize}, on: #{Time.now}" 
      puts "========================================"
      puts
    end
    
  end
end
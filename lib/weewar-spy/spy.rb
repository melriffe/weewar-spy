module WeewarSpy
  
  class Spy
    attr_reader :director

    def initialize(params)
      @username = params[:username]
      WeewarSpy::API.init(params)
      @director = WeewarSpy::Director.new(@username)
    end

    def games
      @director.games
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
    
    # Returns a debriefing report. If +output+ is true (the default) then
    # the report is sent to the #print method of +stream+.
    # +stream+ can be any object that has a #print method.
    # Returns the report string.
    def debrief(game, output = true, stream = $stdout)
      report = ''
      report += "Official Debrief: #{game.name}\n"
      report += "----------------------------------------\n"
      report += game.basic_info + "\n"
      game.players.each do |player|
        report += "--------------------\n"
        report += player.basic_info + "\n"
        report += "\t" + player.troop_info + "\n"
        ext_info = player.extended_troop_info
        unless ext_info.empty?
          report += "\t~~~~~~~~~~~~~~~~~~~~\n"
          report += "\tExtended Troop Info:\n"
          report += ext_info + "\n"
          report += "\t~~~~~~~~~~~~~~~~~~~~\n"
        end
        report += "\t" + player.terrain_info + "\n"
        ext_info = player.extended_terrain_info
        unless ext_info.empty?
          report += "\t~~~~~~~~~~~~~~~~~~~~\n"
          report += "\tExtended Terrain Info:\n"
          report += ext_info + "\n"
          report += "\t~~~~~~~~~~~~~~~~~~~~\n"
        end
        report += "\t" + player.salary_info + "\n"
      end
      report += "----------------------------------------\n"
      report += "For Director #{director.name.capitalize}, on: #{Time.now.strftime('%d %b %Y; %H:%M %Z')}\n"
      report += "========================================\n"
      report += "\n"

      stream.print report if output
      report
    end
    
  end
end
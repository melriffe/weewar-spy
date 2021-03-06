module WeewarSpy
  class Game
    attr_reader :name, :id, :url, :credits_per_base, :initial_credits, :round
    attr_reader :state, :pending_invites, :pace
    attr_reader :type, :rated
    attr_reader :map, :map_url
    attr_reader :playing_since
    attr_reader :players
    
    def self.infiltrate(id)
      # issue a gamestate API call
      xml = XmlSimple.xml_in(
        WeewarSpy::API.get("/gamestate/#{id}"), 
        {
          'ForceArray' => ['faction', 'player', 'terrain', 'unit'], 
          'GroupTags' => {'players' => 'player'}
        })

      Game.new(id, xml)
    end
    
    def self.reconnoiter(id)
      # issue a game API call
      xml = XmlSimple.xml_in(
        WeewarSpy::API.get("/game/#{id}"), 
        {
          'ForceArray' => ['map'], 
          'GroupTags' => {'players' => 'player'}
        })

      Game.new(id, xml)
    end
    
    def initialize(id, xml)
      @id = id.to_i
      @name = xml['name']
      @round = xml['round'].to_i
      @state = xml['state']
      @pending_invites = xml['pendingInvites']
      @pace = xml['pace'].to_i
      @type = xml['type']
      @url = xml['url']
      @rated = xml['rated']
      @map = xml['map']
      @map_url = xml['mapUrl']
      @credits_per_base = xml['creditsPerBase'].to_i
      @initial_credits = xml['initialCredits'].to_i
      @playing_since = Time.parse(xml['playingSince']).getlocal
      
      @players = []
      xml['players'].map {|player| @players << WeewarSpy::Faction.new(player, self)}
      
      if xml.has_key? 'factions'
        xml['factions']['faction'].each_with_index do |faction_xml, ordinal|
          unless faction_xml['state'] == 'open'
            player_name = faction_xml['playerName']
            player = @players.detect {|p| p.name == player_name}
            player.faction(faction_xml) unless player.nil?
          end
        end
      end
      
    end
    
    def current_player
      @players.detect {|player| player.current?}
    end
    
    def abandoned_players
      @players.select {|player| player.abandoned?}
    end
    
    def surrendered_players
      @players.select {|player| player.surrendered?}
    end
    
    def factions
      @players
    end
    
    def limit
      duration(pace)
    end
    
    def report
      # FIXME: Report Generation
      report = "Round: #{round}; Rated: #{rated}; Pace: #{report_duration(pace)};\n"
      report += "Current Player: #{current_player.name}, playing for: #{report_duration(Time.now - playing_since)}\n" unless current_player.nil?
      players.each do |player|
        report += player.report
      end
      report
    end
    
    private
    
      def duration(seconds)
        days = hours = mins = 0
        seconds = seconds.to_i
        if seconds >= 60 then
          mins = (seconds / 60).to_i 
          seconds = (seconds % 60 ).to_i

          if mins >= 60 then
            hours = (mins / 60).to_i 
            mins = (mins % 60).to_i

            if hours >= 24 then
              days = (hours / 24).to_i
              hours = (hours % 24).to_i
            end
          end
        end
        [days, hours, mins, seconds]
      end
      
      def report_duration(seconds)
        report = ""
        limit = duration(seconds)
        if (limit[0] > 0)
          report += (limit[0].to_s + " day")
          report += "s" if limit[0] > 1
        end
        if (limit[1] > 0)
          report += " " unless report.empty?
          report += (limit[1].to_s + " hour")
          report += "s" if limit[1] > 1
        end
        if (limit[2] > 0)
          report += " " unless report.empty?
          report += (limit[2].to_s + " minute")
          report += "s" if limit[2] > 1
        end
        if (limit[3] > 0)
          report += " " unless report.empty?
          report += (limit[3].to_s + " seconds")
        end
        report
      end
      
  end
end

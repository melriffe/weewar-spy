module WeewarSpy
  class User
    attr_reader :name, :id, :points, :profile, :profile_image, :profile_text
    attr_reader :draws, :victories, :losses
    attr_reader :account_type, :on, :ready_to_play, :games_running
    attr_reader :last_login, :bases_captured, :credits_spent
    attr_reader :favorite_units, :preferred_players, :preferred_by, :maps
    
    def initialize(username_or_id)
      xml = XmlSimple.xml_in(
        WeewarSpy::API.get("/user/#{username_or_id}"), 
        {
          'ForceArray' => ['map'], 
          'GroupTags' => {'favoriteUnits' => 'unit', 'preferredPlayers' => 'player', 'preferredBy' => 'player'}
        })
      
      @name = xml['name']
      @id = xml['id'].to_i
      @points = xml['points'].to_i
      @profile = xml['profile']
      @profile_image = xml['profileImage']
      @profile_text = xml['profileText']
      @draws = xml['draws'].to_i
      @victories = xml['victories'].to_i
      @losses = xml['losses'].to_i
      @account_type = xml['accountType']
      @on = (xml['on'] == "true")
      @ready_to_play = (xml['readyToPlay'] == "true")
      @games_running = xml['gamesRunning'].to_i
      @last_login = Time.parse(xml['lastLogin']).getlocal
      @bases_captured = xml['basesCaptured']
      @credits_spent = xml['creditsSpent']
      
      @favorite_units = []
      if xml['favoriteUnits'].is_a? Hash
        @favorite_units << xml['favoriteUnits']['code']
      else
        xml['favoriteUnits'].map {|unit| @favorite_units << unit['code']}
      end

      @preferred_players = {}
      if xml['preferredPlayers'].is_a? Hash
        @preferred_players[xml['preferredPlayers']['id']] = xml['preferredPlayers']['name']
      else
        xml['preferredPlayers'].map {|player| @preferred_players[player['id']] = player['name'] }
      end
      
      @preferred_by = {}
      if xml['preferredBy'].is_a? Hash
        @preferred_players[xml['preferredBy']['id']] = xml['preferredBy']['name']
      else
        xml['preferredBy'].map {|player| @preferred_by[player['id']] = player['name'] }
      end
      
      @maps = Array.new
    end
    
  end
  
  
  class Director < User
    attr_reader :games
    
    def initialize(username_or_id)
      super(username_or_id)
      @games = {}
      xml = XmlSimple.xml_in(
        WeewarSpy::API.get("/headquarters"), 
        {
          'ForceArray' => ['game']
        })
        
      xml['game'].map {|game| @games[game['id'].to_i] = game['name'] }
    end
    
  end
  
end
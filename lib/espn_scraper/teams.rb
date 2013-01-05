module ESPN

  def self.get_teams_in(league)
    doc = self.get(league, 'teams')
    divisions = {}
	
    doc.css('.mod-teams-list-medium').each do |division|
      key = division.at_css('.mod-header h4 text()').content.gsub(/division/i, '').dasherize
      divisions[key] = division.css('.mod-content li').map do |team|
        team_name = team.at_css('h5 a.bi').content
        data_name, slug = team.at_css('h5 a.bi')['href'].split('/').last(2)
        
        name_addition = slug.sub(team_name.dasherize, '').split('-').reject(&:empty?).each do |word| 
          word.capitalize!
        end.join(' ')
        
        team_name = "#{ team_name.sub(/\(.*\)/, '').strip } #{ name_addition }".split.join(' ')
        { name: team_name, data_name: data_name }
      end
    end
    divisions
  end

end
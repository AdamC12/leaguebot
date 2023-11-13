# frozen_string_literal: true
require 'httparty'
require 'pry'
class SummonerApi

  def initialize(summoner_name)
    @summoner_name = summoner_name
  end
  def get_summoner_puuid
    request = "https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{@summoner_name}?api_key=#{ENV['APIKEY']}"
    response = HTTParty.get(request)
    @puuid = response['puuid']
  end

  def get_soloq_matches_for_puuid
    request = "https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/#{@puuid}/ids?queue=420&start=0&count=20&api_key=#{ENV['APIKEY']}"
    response = HTTParty.get(request)
    @matches = response
  end

  def get_unique_champions
    champion_list = []
    @matches.each do |match|
      request = "https://europe.api.riotgames.com/lol/match/v5/matches/#{match}?api_key=#{ENV['APIKEY']}"
      response = HTTParty.get(request)
      champion_list << response['info']['participants'].detect{|h| h['summonerName'].downcase == @summoner_name.downcase}['championName']
    end

    champion_list.uniq.count
  end

  def get_unique_champion_list
    get_summoner_puuid
    get_soloq_matches_for_puuid
    unique_champions = get_unique_champions
    if unique_champions < 6
      message = "#{@summoner_name}, you've only played #{unique_champions} champs in your last 20 soloq games! good for you!"
    else
      message = "#{@summoner_name}, stop playing so many champions! you've played #{unique_champions} in 20 games you degenerate"
    end
    message
  end
end

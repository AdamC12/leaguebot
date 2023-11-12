# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require 'httparty'
require 'pry'

def get_summoner_puuid(summoner_name)
  request = "https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}?api_key=#{ENV['APIKEY']}"
  response = HTTParty.get(request)
  @puuid = response['puuid']
end

def get_soloq_matches_for_puuid(puuid=@puuid)
  request = "https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?queue=420&start=0&count=20&api_key=#{ENV['APIKEY']}"
  response = HTTParty.get(request)
  @matches = response
end

def get_unique_champions(summoner)
  champion_list = []
  @matches.each do |match|
    request = "https://europe.api.riotgames.com/lol/match/v5/matches/#{match}?api_key=#{ENV['APIKEY']}"
    response = HTTParty.get(request)
    champion_list << response['info']['participants'].detect{|h| h['summonerName'] == summoner}['championName']
  end

  champion_list.uniq.count
end

def get_unique_champion_list_for(summoner_name)
  puuid = get_summoner_puuid(summoner_name)
  get_soloq_matches_for_puuid(puuid)
  unique_champions = get_unique_champions(summoner_name)
  if unique_champions < 6
    p "you've only played #{unique_champions} champs in your last 20 soloq games! good for you!"
  else
    p "stop playing so many champions! you've played #{unique_champions} in 20 games you degenerate"
  end
end

get_unique_champion_list_for('Lasciel')
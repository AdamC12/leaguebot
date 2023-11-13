# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require_relative 'class/summoner_api_adapter'


bot = Discordrb::Bot.new token: ENV['DISCORDTOKEN'], client_id: 1172880556917276752

bot.message(start_with: '!champions') do |event|
  summoner = event.message.content.split[1..-1].join(' ')
  summoner = SummonerApiAdapter.new(summoner)
  message = summoner.get_unique_champion_list
  event.respond message
end

bot.run

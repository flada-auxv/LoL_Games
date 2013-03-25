require "lol_games/version"
require "lol_games/core_ext/module"
using LolGames::CoreExt

require 'yaml'
require 'hashie'
require 'readline'

# TODO quitで終了した時になんか表示されとるぞ！
module LolGames

  # Gameスコープ配下のClass名一覧を返す
  def self.game_list
    Game.module_eval do 
      constants.map { |c|
        const_get(c)
      }.find_all { |c|
        c.class == Class
      }
    end
  end

  def self.chose_game
    puts "enter the number from the list below:"
    games = {}
    game_list.map(&:to_s).each_with_index do |klass, idx|
      games[idx.next.to_s] = klass.name
    end

    input = Readline.readline(">> ", true)
    if games.keys.include?(input)
      games[input]
    else
      puts "bye!"
      exit
    end
  end

  module Game
    class WizardWorld
      def initialize
        @env = Hashie::Mash.new(YAML.load_file("lib/lol_games/world.yml"))
        @allowed_commands = %w(look walk pickup inventory)
        @location = :living_room
  
        repl
      end
      
      def look
        res = []
        res << describe_location(@location)
        res << describe_paths(@location)
        res << describe_objects(@location)
        res.join("\n")
      end
      
      def describe_location(location)
        @env.node[location].desc
      end
      
      def describe_paths(location)
        @env.node[location].edges.map { |edge| 
          "there is a #{edge[:to]} going #{edge[:direction]} from here."
        }.join("\n")
      end
      
      def describe_objects(location)
        return unless objs = @env.objects[location]
        objs.map { |obj| "you see a #{obj} on the floor." }.join("\n")
      end
      
      def pickup(object)
        if @env.objects[@location].include?(object)
          @env.objects[@location].delete(object)
          @env.objects[:body].push(object)
          "you are now carrying the #{object}."
        else
          "you cannot get that."
        end
      end
      
      def inventory
        items = @env.objects[:body].join(", ")
        items = "none" if items.empty?
        "items: #{items}."
      end
      
      def walk(direction)
        if next_edge = @env.node[@location].edges.find { |edge| edge[:direction] == direction.to_sym }
          @location = next_edge[:to]
          look
        else
          "you cannot go that way."
        end
      end
      
      def usage
        @env.commands.map { |cmd, args|
          str = "[#{cmd[0]}]#{cmd[1..-1]}"
          args = args.map { |a| %Q(\"#{a}\") }.join(" ")
          str << " #{args}" unless args.empty?
          str
        }.join(", ")
      end
  
      def repl
        loop do
          unless input = Readline.readline(">> ", true)
            puts "please enter any commands."
            puts usage
            next 
          end
        
          cmd, *args = input.chomp.split
          if cmd == "quit"
            puts "bye-bye!"
            break
          elsif @env.commands.keys.include?(cmd)
            cmd << args.map { |arg| " \"#{arg}\"" }.join
            puts eval(cmd)
          else
            puts "invalid command."
            puts usage
          end
          puts ""
        end
      end
  
    end
  end
end

module LolGames
  module CoreExt
    refine Module do
      def class_name
        name.split("::").last
      end
    end
  end
end

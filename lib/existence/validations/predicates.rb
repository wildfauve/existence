module Existence

  module ValidationPredicates
    include Dry::Logic::Predicates

    predicate(:email?) do |value|
      ! /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/.match(value).nil?
    end

    predicate(:uri?) do |value|
      ! /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/.match(value).nil?
    end

    predicate(:url_path?) do |value|
      ! /^[a-z0-9]+[a-z0-9(\/)(\-)]*[a-z0-9]+$/
    end

    predicate(:urn?) do |value|
     ! /\A(?i:urn:(?!urn:)[a-z0-9][a-z0-9-]{1,31}:(?:[a-z0-9()+,-.:=@;$_!*']|%[0-9a-f]{2})+)\z/.match(value).nil?
    end

  end

end

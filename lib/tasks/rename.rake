require "rake"

task :rename => :environment do
	# Find duplicates and update Ingredients name to be more simple based on user input.
	last_original_name = nil
	last_new_name = nil
	Ingredient.order(:name).each do |i|
		if(i[:name] == last_original_name)
			puts "#{i[:name]} and #{last_new_name} match."
			i.update(searchable: last_new_name)
		else
			puts original_name = i[:name]
			new_name = STDIN.gets.chomp
			i.update(searchable: new_name)
			last_new_name = new_name
			last_original_name = original_name
		end
	end
end

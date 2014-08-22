module PersonHelper
  def disambiguate_names(people)
    name_counts = Hash.new(0)

    people.each do |p|
      key = forename_surname(p)
      name_counts[key] += 1
    end

    people.map do |p|
      if name_counts[forename_surname(p)] > 1
        disambiguate_option p
      else
        option p
      end
    end
  end

  def forename_surname(person)
    [person.forename, person.surname].join(' ')
  end

  def disambiguate_option(person)
    [person.name_with_disambiguator, person.id]
  end

  def option(person)
    [person.name, person.id]
  end
end

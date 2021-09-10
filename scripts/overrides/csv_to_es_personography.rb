class CsvToEsPersonography < CsvToEs
  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  ##########
  # Field Builders #
  ##########

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end
  
  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  def category
    "People"
  end

  def subcategory
    "Person"
  end

  def date_display
    built_date_display = Array.[]
    built_date_display << @row["birth"]
    built_date_display << @row["Death"]
    return array_to_string(built_date_display," - ")
  end

  def title
    built_title = Array.[]
    if @row["fullname"]
      
      built_title << @row["fullname"]
    else
      built_title << "#{@row["forename"]}, #{@row["surname"]}"
    end
    built_title << "(Person)"
    return array_to_string(built_title," ")
  end

  # Notes for fields to add later
  # id [done]
  # fullname (person, selected_people)
  # match [skip]
  # surname (text)
  # forename (text)
  # birth (date, html)
  # birth - placename (html)
  # Death (date, html)
  # death - placename (html)
  # residence (africa)  (html)
  # residence (other)  (html)
  # occupation  (html)
  # VIAF  (html)

  def text
    built_text = Array.[]
    built_text << @row["fullname"]
    built_text << @row["surname"]
    built_text << @row["forename"]
    built_text << @row["occupation"]
    return array_to_string(built_text," ")
  end

end

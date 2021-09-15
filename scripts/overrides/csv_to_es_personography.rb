class CsvToEsPersonography < CsvToEs
  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  ##########
  # Field Builders #
  ##########

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end

  def build_name
    built_fullname = Array.[]
    if @row["fullname"]
      built_fullname << @row["fullname"]
    else
      built_fullname << @row["surname"].to_s
      if not(@row["forename"].to_s.empty?) || not(@row["forename"].nil?)
        built_fullname << ", "
      end
      built_fullname << @row["forename"].to_s
      if built_fullname.empty?
        built_fullname << "no name in spreadsheet"
      end
    end
    return array_to_string(built_fullname,"")
  end
  
  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  def assemble_collection_specific
    @json["person_selected_k"] = build_name
  end

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
    return "#{build_name} (Person)"
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

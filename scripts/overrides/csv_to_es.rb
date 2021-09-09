

class CsvToEs
  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  # --- personography ---
  if @filename == "personography"

      def category
        "Personography"
      end

  # --- gallery ---
  elsif @filename.to_s.include?("gallery")

    def id
      @row["identifier"]
    end
  
    def category
      @filename
    end

    def subcategory
      @row["subtype"].capitalize()
    end

    def date_display
      @row["date"]
    end

  else 
    # do nothing
  end

    def subcategory
      @filename.to_s
    end



end

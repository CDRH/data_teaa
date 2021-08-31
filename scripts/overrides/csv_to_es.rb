class CsvToEs
  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  def id
    @row["identifier"]
  end

  def category
    "Gallery"
  end

  def subcategory
    @row["subtype"].capitalize()
  end

  def date_display
    @row["date"]
  end
end
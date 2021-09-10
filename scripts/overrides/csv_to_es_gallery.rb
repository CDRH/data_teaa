class CsvToEsGallery < CsvToEs

  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end

  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  def category
      "Gallery"
  end

  def subcategory
      @row["subtype"].capitalize()
  end

  def date_display
      @row["date"]
  end

  # person, creator.name
  def person
    @row["creator.name"]
  end

  #theme

  def text
    annotation_id = @row["identifier"]
    annotation_path = "source/gallery_html/#{annotation_id}.html"
    annotation_data = (File.exist?(annotation_path))  ? File.read(annotation_path) : ""
    annotation_text = Nokogiri::HTML(annotation_data).text.gsub(/\n/," ")

    built_text = []
    #todo: add more text to fields

    @row.each do |key, value|
      built_text << value.to_s.gsub('"',"")
    end

    built_text << annotation_text

    return array_to_string(built_text," ")
  end

end

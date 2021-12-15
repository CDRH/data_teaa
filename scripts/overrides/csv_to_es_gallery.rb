class CsvToEsGallery < CsvToEs

  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end

  def build_image_id
    built_image_id = []
    built_image_id << @row["identifier"]
    built_image_id << ".jpg"
    return array_to_string(built_image_id,"")
  end


  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  def image_id
    build_image_id
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

  # person, creator.name
  def creator
    if @row["creator.name"]
      @row["creator.name"].split("; ").map do |p|
        { "name" => p }
      end
    end
  end

  def person
    if @row["creator.name"]
      @row["creator.name"].split("; ").map do |p|
        { "name" => p }
      end
    end
  end

  #theme

  def text
    annotation_id = @row["identifier"]
    annotation_path = "source/gallery_html/#{annotation_id}.html"
    annotation_data = (File.exist?(annotation_path))  ? File.read(annotation_path) : ""
    annotation_text = Nokogiri::HTML(annotation_data).text.gsub(/\n/," ")

    built_text = []

    @row.each do |key, value|
      built_text << value.to_s.gsub('"',"")
    end

    built_text << annotation_text

    return array_to_string(built_text," ")
  end

end

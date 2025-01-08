class CsvToEsGallery < CsvToEs

  # Note to add custom fields, use "assemble_collection_specific" from request.rb
  # and be sure to either use the _d, _i, _k, or _t to use the correct field type

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end

  def build_cover_image
    built_cover_image = []
    built_cover_image << @row["identifier"]
    built_cover_image << ".jpg"
    return array_to_string(built_cover_image,"")
  end


  ##########
  # FIELDS #
  ##########
  # Original fields:
  # https://github.com/CDRH/datura/blob/master/lib/datura/to_es/csv_to_es/fields.rb

  def page_data
    if @row["page"]
      @row["page"]
    end
  end

  def assemble_collection_specific
    @json["ethnicgroup_k"] = ethnicgroup_data
    @json["pages_k"] = page_data
    #@json["format_k"] = "image"
  end

  # ethnic groups go in ethnicgroup_k field
  def ethnicgroup_data
    if @row["ethnic.group"]
      @row["ethnic.group"].split(";").map(&:strip)
    end
  end
  
    # added in assemble_collection_specific
  # end ethnic groups

  # powers go in keywords field
  def powers_data
    if @row["powers"]
      @row["powers"].split(";").map!(&:strip)
    end
  end

  def keywords
    powers_data
  end
  # end powers

  # themes go in topics field
  def theme_data
    if @row["theme"]
      @row["theme"].split(";").map!(&:strip)
    end
  end

  def topics
    theme_data
  end
  # end themes
  
  def cover_image
    build_cover_image
  end

  def category
      "Gallery"
  end

  def category2
      @row["subtype"].capitalize()
  end

  def date_display
      @row["date_display"]
  end

  def format
    "image"
  end

  # person, creator.name
  def creator
    if @row["creator.name"]
      @row["creator.name"].split("; ").map do |p|
        { "name" => p }
      end
    end
  end

  # gather all people from the creator.name and the people field, add them to an array
  def person_name_data
    people_names = []
    if @row["people"]
      people_names = @row["people"].split(";").map!(&:strip)
    end

    creator_names = []
    if @row["creator.name"]
      creator_names = @row["creator.name"].split(";").map!(&:strip)
    end

    people_names += creator_names
    people_names.uniq
  end

  def person
    person_name_data.map do |p|
      { "name" => p }
    end
  end

  def has_source
    if @row["source"]
      { "title" => @row["source"] }
    end
  end

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

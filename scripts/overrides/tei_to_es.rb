class TeiToEs

  ################
  #    XPATHS    #
  ################

  def override_xpaths
    xpaths = {}
    xpaths["category"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='type'][1]/term"
    xpaths["subcategory"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='subtype']/term"
    xpaths["language"] = "//langUsage/language/@ident"
    xpaths["publisher"] = "/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/publisher[1]"
    xpaths["bibliography"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]"
    xpaths["title_a"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/bibl/title[@level='a']"
    xpaths["title_m"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/bibl/title[@level='m']"
    xpaths["title_j"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/bibl/title[@level='j']"
    xpaths["pub_place"] = "/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/pubPlace"
    xpaths["pub_date"] = "/TEI/teiHeader/fileDesc/sourceDesc/bibl[1]/date"
    xpaths["pub_date2"] = "/TEI/teiHeader/fileDesc/sourceDesc/bibl[last()-1]/date"
    xpaths["volume"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/bibl/biblScope[@unit='vol']"
    xpaths["pages"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/bibl/biblScope[@unit='pages']"
    xpaths["issue"] = "/TEI/teiHeader[1]/fileDesc[1]/sourceDesc[1]/bibl/biblScope[@unit='issue']"

    xpaths["people"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='people'][1]/term"
    xpaths["keywords"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='powers'][1]/term"
    xpaths["topics"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='theme'][1]/term"
    xpaths["ethnicgroup"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='ethnic_group'][1]/term"
    xpaths["religion"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='religion'][1]/term"
    xpaths["places"] = [
      "/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term",
      "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='sentBy']/placeName",
      "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='deliveredTo']/placeName"
    ]
    xpaths["contributor"] = [
      "/TEI/teiHeader/revisionDesc/change/name",
      "/TEI/teiHeader/fileDesc/titleStmt/respStmt/name"
    ]
    xpaths["recipient"] = "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='deliveredTo']/persName"

    xpaths["sender"] = "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='sentBy']/persName"

    xpaths["analysis_file"] = "//ref[@type='analysis']/@target"

    return xpaths
  end

  #################
  #    GENERAL    #
  #################

  # do something before pulling fields
  def preprocessing
    # read additional files, alter the @xml, add data structures, etc
  end

  # do something after pulling the fields
  def preprocessing
    people_file_location = File.join(@options["collection_dir"], "source/csv/personography.csv")
    @people = CSV.read(people_file_location, **{
      encoding: "utf-8",
      headers: true,
      return_headers: true
    })
  end

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end

  ########################
  #    Helpers Builders    #
  ########################

  

  def assemble_collection_specific
    @json["ethnicgroup_k"] = get_list(@xpaths["ethnicgroup"])
    @json["religion_k"] = get_list(@xpaths["religion"])
    @json["person_selected_k"] = build_selected_person
    @json["person_sender_k"] = build_sender
    # some of the below moved to citation field
    # @json["title_a_k"] = get_text(@xpaths["title_a"])
    # @json["title_m_k"] = get_text(@xpaths["title_m"])
    # @json["title_j_k"] = get_text(@xpaths["title_j"])
    @json["author_cite_k"] = get_text(@xpaths["creator"])
    #@json["volume_k"] = get_text(@xpaths["volume"])
    #@json["pages_k"] = get_text(@xpaths["pages"])
    #@json["issue_k"] = get_text(@xpaths["issue"])
    #@json["pub_place_k"] = get_text(@xpaths["pub_place"])
    # date field could be moved to citation field but 
    @json["pub_date_k"] = get_text(@xpaths["pub_date"])
    @json["pub_date2_k"] = get_text(@xpaths["pub_date2"])
  end

  def build_person_obj(personXml)
    xmlid = personXml["id"]
    pers_select = array_to_string(personXml.xpath("text()"),"") 
    display_name = (pers_select == "") ? "unknown" : pers_select
    {
      "id" => xmlid,
      "name" => display_name,
      "role" => ""
    }
  end

  def build_selected_person
    list = []
    #people_in_doc = get_list(@xpaths["person"])

    people_in_doc = get_list(@xpaths["person"]).to_a + get_list(@xpaths["sender"]).to_a + get_list(@xpaths["recipient"]).to_a + get_list(@xpaths["creator"]).to_a



    people_in_doc.each do |p|
      if p != ""
        row = @people.find { |row| row["Full Name"].to_s == p }
        if row != nil
          list << p
        end
      end
    end
    return list
  end

  def build_sender
    list = []
    eles = get_elements(@xpaths["sender"]).map do |p|
      persname = get_text(".", xml: p)
      if persname != ""
        list << persname
      end
    end
    list.uniq
  end

  def build_format
    formats = get_elements(@xpaths["bibliography"]).map do |ele|
      if (get_text("bibl/title/@level", xml: ele).to_s.include? "a") && (get_text("bibl/title/@level", xml: ele).to_s.include? "m")
      	if (get_text("bibl/title[@level='m']/@type", xml: ele).to_s.include? "main")
      		"book"
      	elsif (get_text("bibl/title[@level='a']/@type", xml: ele).to_s.include? "main")
      		"other"
      	elsif get_text(@xpaths["subcategory"]) == "Despatches"
        	"despatch"
        else
          "no format defined"
        end
      elsif (get_text("bibl/title/@level", xml: ele).to_s.include? "a") && (get_text("bibl/title/@level", xml: ele).to_s.include? "j")
        "article"
      else
        "no format defined"
      end
    end
    array_to_string(formats.uniq,",")
  end

  ########################
  #    Field Builders    #
  ########################

  def has_source
    {
      "title" => build_source
    }
  end

  def citation
    {
      "title_a" => get_text(@xpaths["title_a"]),
      "title_m" => get_text(@xpaths["title_m"]),
      "title_j" => get_text(@xpaths["title_j"]),
      "volume" => get_text(@xpaths["volume"]),
      "page_start" => get_text(@xpaths["pages"]),
      "issue" => get_text(@xpaths["issue"]),
      "place" => get_text(@xpaths["pub_place"]),
      "publisher" => get_text(@xpaths["publisher"])
      # omitting date for now because it's not possible to parse all values
      # "date" => Datura::Helpers.date_standardize(get_text(@xpaths["pub_date"]), false)
    }
  end

  def person
    combined_people_array = get_elements(@xpaths["person"]) + get_elements(@xpaths["sender"]) + get_elements(@xpaths["creator"])
    eles = combined_people_array.map do |p|
      if (get_text(".", xml: p) != nil)
        {
          "id" => get_text("@ref", xml: p),
          "name" => get_text(".", xml: p),
          "role" => get_text("@role", xml: p)
        }
      else
        next
      end
    end
    eles.concat(build_recipient)
    eles.uniq.compact
  end

  def build_recipient
    eles = get_elements(@xpaths["recipient"]).map do |p|
      persname = get_text(".", xml: p)
      if persname != nil
        {
          "id" => get_text("@id", xml: p),
          "name" => persname,
          "role" => "recipient"
        }
      end
    end
    eles.uniq.compact
  end
  
  def build_source
    source = ""
    #format_k = build_format
    title_j = get_text(@xpaths["title_j"])
    title_m = get_text(@xpaths["title_m"])
    if title_j != nil
      source = title_j
    elsif title_m != nil
      source = title_m
    else
      source = "No source defined"
    end
    source
  end

  def call_analysis_file(filename)
    analysis_xml_file = @options["collection_dir"] + "/source/analysis/" + filename + ".xml"

    if (File.exist?(analysis_xml_file))
      analysis_object = CommonXml.create_xml_object(
        File.join(analysis_xml_file)
      )
    analysis_text = get_text("//text", xml: analysis_object)
    return analysis_text
    end

  end

  def format
    build_format
  end

  def text
    analysis = get_text(@xpaths["analysis_file"]).to_s
    # puts analysis
    analysis_text = call_analysis_file(analysis)

    # handling separate fields in array
    # means no worrying about handling spacing between words
    text_all = []

    

    # This is a cheaty way to make sure the analysis docs show up when 
    # you search for analysis, needed until datura issue #179 is solved
    if analysis_text != '' && analysis_text != nil
      text_all << " Analysis "
    end

    body = get_text(@xpaths["text"], keep_tags: false)
    
    text_all << analysis_text
    text_all << body
    # TODO: do we need to preserve tags like <i> in text? if so, turn get_text to true
    # text_all << CommonXml.convert_tags_in_string(body)
    text_all += text_additional
    Datura::Helpers.normalize_space(text_all.join(" "))
  end

  def spatial
    places = []
    if get_list(@xpaths["places"])
      get_list(@xpaths["places"]).each do |place|
        places << {
          "short_name" => place
        }
      end
    end
    places
  end

end

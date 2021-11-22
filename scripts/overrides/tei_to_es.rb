class TeiToEs

  ################
  #    XPATHS    #
  ################

  def override_xpaths
    xpaths = {}
    xpaths["category"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='type'][1]/term"
    xpaths["subcategory"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='subtype']/term"
    xpaths["language"] = "//langUsage/language/@ident"
    xpaths["publisher"] = "//div2[@type='bibliography']/bibl/publisher"
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
      "/TEI/teiHeader/fileDesc/titleStmt/editor",
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
    @people = CSV.read(people_file_location, {
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

  # def selected_person_id
  #   list = []
  #   people_in_doc = get_list(@xpaths["person"])
  #   people_in_doc.each do |p|
  #     if p != ""
  #       row = @people.select { |row| row["Full Name"].to_s == p }
  #       if row != nil
  #         list << p
  #       end
  #     end
  #   end
  #   return list
  # end

  def build_selected_person
    list = []
    people_in_doc = get_list(@xpaths["person"])
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

  ########################
  #    Field Builders    #
  ########################

  def person
    eles = get_elements(@xpaths["person"]).map do |p|
      if (get_text(".", xml: p) != "" && get_text(".", xml: p) != nil)
        {
          "id" => get_text("@ref", xml: p),
          "name" => get_text(".", xml: p),
          "role" => get_text("@role", xml: p)
        }
      else
        next
      end
    end
    eles.uniq.compact
  end

  def recipient
    eles = get_elements(@xpaths["recipient"]).map do |p|
      persname = get_text(".", xml: p)
      if persname != ""
        {
          "id" => get_text("@id", xml: p),
          "name" => persname,
          "role" => "recipient"
        }
      end
    end
    eles.uniq.compact
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

  def text
    analysis = get_text(@xpaths["analysis_file"])
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

end

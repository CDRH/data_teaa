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
    xpaths["recipient"] = "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='deliveredTo']/persName"

    xpaths["sender"] = "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='sentBy']/persName"

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
    file_location = File.join(@options["collection_dir"], "source/csv/personography.csv")
    @people = CSV.read(file_location, {
      encoding: "utf-8",
      headers: true,
      return_headers: true
    })
  end

  def array_to_string (array,sep)
    return array.map { |i| i.to_s }.join(sep)
  end

  ########################
  #    Field Builders    #
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

  def build_selected_person
    list = []
    people_in_doc = get_list(@xpaths["person"])
    people_in_doc.each do |p|
      if p != ""
        row = @people.find { |row| row["fullname"].to_s == p }
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

  def person
    eles = get_elements(@xpaths["person"]).map do |p|
      persname = get_text(".", xml: p)
      if persname != ""
        {
          "id" => get_text("@id", xml: p),
          "name" => persname,
          "role" => get_text("@role", xml: p)
          # not setting role currently, since we have separate receiver, sender, creator
        }
      end
    end
    eles.uniq
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
    eles.uniq
  end

end

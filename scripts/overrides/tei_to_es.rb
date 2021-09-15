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

    xpaths["keywords"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='empires'][1]/term"
    xpaths["topics"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='theme'][1]/term"

    xpaths["ethnicgroup"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='ethnic_group'][1]/term"
    xpaths["religion"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='religion'][1]/term"

    xpaths["places"] = [
      "/TEI/teiHeader/profileDesc/textClass/keywords[@n='places']/term",
      "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='sentBy']/placeName",
      "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='deliveredTo']/placeName"
    ]

    xpaths["recipient"] = "/TEI/teiHeader/profileDesc/correspDesc/correspAction[@type='deliveredTo']/persName"
    xpaths["person"] = "//persName"

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
  
  def build_selected_person
    list = []
    people_in_doc = @xml.xpath(@xpaths["person"])
    people_in_doc.each do |p|
      persname = p.xpath("text()").to_s
      if persname != ""
        row = @people.find { |row| row["fullname"].to_s == persname }
        if row != nil
          list << row["fullname"]
        end
        
      end
    end
    return list
  end

  def assemble_collection_specific
    @json["ethnicgroup_k"] = get_list(@xpaths["ethnicgroup"])
    @json["religion_k"] = get_list(@xpaths["religion"])
    @json["person_selected_k"] = build_selected_person
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

  

  # person is pulling fine without the code below, but the role is not populating. Given that we already have separate creator and recipient fields though, O am not sure it is necessary?

  def person
    list = []
    people = @xml.xpath(@xpaths["person"])
    people.each do |p|
      personname = array_to_string(p.xpath("text()"),"")
      # exclude blank people so there is no "unknown" or "No Label"
      if personname != ""
        person = build_person_obj(p)
        # get parent element to determine the role
        parent_type = p.parent["type"]
        if parent_type
          role = "recipient" if parent_type == "deliveredTo"
          role = "creator" if parent_type == "sentBy"
          person["role"] = role
        end
        list << person
      end
    end
    return list.uniq
  end

  def recipient
    list = []
    people = @xml.xpath(@xpaths["recipient"])
    people.each do |p|
      person = build_person_obj(p)
      # get parent element to determine the role
      parent_type = p.parent["type"]
      if parent_type
        role = "recipient" if parent_type == "deliveredTo"
        role = "creator" if parent_type == "sentBy"
        person["role"] = role
      end
      list << person
    end
    return list.uniq

  end

end

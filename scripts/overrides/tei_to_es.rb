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
  def postprocessing
    # change the resulting @json object here
  end

  ########################
  #    Field Builders    #
  ########################

  def assemble_collection_specific
    @json["ethnicgroup_k"] = get_list(@xpaths["ethnicgroup"])
    @json["religion_k"] = get_list(@xpaths["religion"])
  end

end

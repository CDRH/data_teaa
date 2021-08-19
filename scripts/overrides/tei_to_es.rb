class TeiToEs

  ################
  #    XPATHS    #
  ################

  def override_xpaths
    xpaths = {}
    xpaths["category"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='type'][1]/term"
    xpaths["subcategory"] = "/TEI/teiHeader/profileDesc/textClass/keywords[@n='subtype']/term"
    xpaths["date"] = "//div2[@type='bibliography']/bibl/date/@when"
    xpaths["date_display"] = "//div2[@type='bibliography']/bibl/date"
    xpaths["language"] = "//langUsage/language/@ident"
    xpaths["publisher"] = "//div2[@type='bibliography']/bibl/publisher"

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

  

end

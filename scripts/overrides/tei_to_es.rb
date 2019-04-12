class TeiToEs < XmlToEs

  def override_xpaths
    {
      "date" => "//div2[@type='bibliography']/bibl/date/@when",
      "date_display" => "//div2[@type='bibliography']/bibl/date",
      "publisher" => "//div2[@type='bibliography']/bibl/publisher"
    }
  end

  def language
    get_text("//langUsage/language/@ident")
  end

  def languages
    [ get_text("//langUsage/language/@ident") ]
  end


end

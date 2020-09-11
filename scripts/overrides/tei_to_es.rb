class TeiToEs < XmlToEs

  def override_xpaths
    {
      "date" => "//div2[@type='bibliography']/bibl/date/@when",
      "date_display" => "//div2[@type='bibliography']/bibl/date",
      "language" => "//langUsage/language/@ident",
      "publisher" => "//div2[@type='bibliography']/bibl/publisher"
    }
  end

end

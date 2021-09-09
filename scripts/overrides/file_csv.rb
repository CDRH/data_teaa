class FileCsv
  # include LocationHelper

  def build_html_from_csv
    # --- personography ---
    if self.filename(false) == "personography"

      # file write for whole personography
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.div(class: "main_content") {
          xml.ul {
            @csv.each_with_index do |row, index|
              next if row.header_row?
              xml.li(row["id"])
            end
          }
        }
      end
      write_html_to_file(builder, "personography")

      # file write for each person
      @csv.each_with_index do |row, index|
        next if row.header_row?
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.div(class: "main_content") {
            xml.ul {
            xml.li(row["id"])
            }
          }
        end
        write_html_to_file(builder, row["id"])
      end
    
    # --- gallery ---
    elsif self.filename(false) == "gallery"
      # currently not writing HTML and pulling 
      # all data from api, will change to add 
      # annotations
    else 
      # do nothing
    end
  end
end

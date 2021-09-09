require_relative "csv_to_es_gallery.rb"
require_relative "csv_to_es_personography.rb"

class FileCsv < FileType
  
  def row_to_es(headers, row)
    if self.filename(false) == "gallery"
      row_to_es_gallery(headers, row)
    elsif self.filename(false) == "personography"
      row_to_es_personography(headers, row)
    else
      print "File not supported"
    end
  end

  def row_to_es_gallery(header, row)
    CsvToEsGallery.new(row, @options, @csv, self.self.filename(false)).json
  end

  def row_to_es_personography(header, row)
    CsvToEsPersonography.new(row, @options, @csv, self.filename(false)).json
  end

  # def transform_es
  #     puts "transforming #{self.filename}"
  #     es_doc = []
  #     @csv.each do |row|
  #       # include first row in personography, will use to generate "all personography" record
  #       if self.filename(false) == "personography"
  #         es_doc << row_to_es(@csv.headers, row)
  #       # remove header row in all other csv's
  #       else
  #         if !row.header_row?
  #           es_doc << row_to_es(@csv.headers, row)
  #         end
  #       end
  #     end
  #     if @options["output"]
  #       filepath = "#{@out_es}/#{self.filename(false)}.json"
  #       File.open(filepath, "w") { |f| f.write(pretty_json(es_doc)) }
  #     end
  #     es_doc
  # end

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

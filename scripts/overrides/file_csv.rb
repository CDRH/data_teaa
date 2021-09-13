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
    CsvToEsGallery.new(row, @options, @csv, self.filename(false)).json
  end

  def row_to_es_personography(header, row)
    CsvToEsPersonography.new(row, @options, @csv, self.filename(false)).json
  end

  def transform_es
    puts "transforming #{self.filename}"
    es_doc = []

    #build personography record here
    if self.filename(false) == "personography"
    end
    
    @csv.each do |row|
      if !row.header_row?

        es_doc << row_to_es(@csv.headers, row)
      end
    end
    if @options["output"]
      filepath = "#{@out_es}/#{self.filename(false)}.json"
      File.open(filepath, "w") { |f| f.write(pretty_json(es_doc)) }
    end

    es_doc
  end

  def build_html_from_csv
    # --- personography ---
    if self.filename(false) == "personography"

      # file write for whole personography
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.div(class: "main_content") {
          @csv.each_with_index do |row, index|
            next if row.header_row?
            name = row["fullname"] ? row["fullname"] : "#{row["forename"]}, #{row["surname"]}"

            xml.div() {
              xml.h2(name)
              xml.ul {
                @csv.headers.each do |header|
                  xml.li("#{header}: #{row[header]}")
                end
              }
            }
          end
        }
      end
      write_html_to_file(builder, "personography")

      # file write for each person
      @csv.each_with_index do |row, index|
        next if row.header_row?
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.div(class: "main_content") {
            xml.ul {
              @csv.headers.each do |header|
                if header != '' && header != nil
                  xml.li("#{header}: #{row[header]}")
                end
              end
            }
            xml.h2("List of files person is mentioned in will go here")
          }
        end
        write_html_to_file(builder, row["id"])
      end
    
    # --- gallery ---
    elsif self.filename(false) == "gallery"
      @csv.each_with_index do |row, index|
        next if row.header_row?

        img_path = File.join(@options["media_base"],
        "iiif/2", "teaa%2F#{row["identifier"]}.jpg", "full", "!800,800", "0/default.jpg")

        builder = Nokogiri::XML::Builder.new do |xml|
          # Reading in annotations
          annotation_id = row["identifier"]
          annotation_path = "source/gallery_html/#{annotation_id}.html"
          annotation_data = (File.exist?(annotation_path))  ? File.read(annotation_path) : ""

          xml.div(class: "main_content") {

            xml.img(src: img_path){}

            if annotation_data != ""
              xml.div {
                xml.h3("Annotations")
                xml << annotation_data
              }
            end
          }
        end
        write_html_to_file(builder, row["identifier"])
      end
    else 
      # do nothing
    end
  end
end

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'tokyocabinet'

module Nearby

  VERSION = '0.0.1' # :nodoc:
  RAD_PER_DEG = 0.017453293 # :nodoc:
  EARTH_RADIUS_KM = 6371 # :nodoc:
  
  # The "geoname" table fields stored in the places database. You can {read
  # more about them
  # here}[http://download.geonames.org/export/dump/readme.txt].
  FIELDS = ["geonameid", "name", "asciiname", "alternatenames", "latitude",
    "longitude", "feature_class", "feature_code", "country_code", "cc2",
    "admin1_code", "admin2_code", "admin3_code", "admin4_code", "population",
    "elevation", "gtopo30", "timezone", "modification_date"]

  class Database
    
    attr_accessor :db # :nodoc:

    # Open a database connection. Accepts the path to the TokyoCabinet db
    # file.
    def initialize(file)
      @db = TokyoCabinet::TDB::new
      @db.open(file, TokyoCabinet::TDB::OREADER)
    end
    
    # Accepts a place hash result from get_place, or anything that responds to
    # \["latitude"\] and \["longitude"\]. Distance must be specified in
    # kilometers. The result is a collection of place hashes. The shorter the
    # distance, the faster the search will run.
    def get_nearby(place, kms)
      high = place["distance"].to_i + kms.to_i
      low = place["distance"].to_i - kms.to_i
      query = TokyoCabinet::TDBQRY.new(db)
      query.addcond("distance", TokyoCabinet::TDBQRY::QCNUMBT, "#{low} #{high}")
      ids = query.search
      ids.collect { |i| db.get(i) }.select { |r|
        Nearby.haversine_distance(place["latitude"], place["longitude"], r["latitude"], r["longitude"]) < kms
      }
    end
    
    # Find place matching :name. You can also specify :country (an ISO country
    # code) and :region (for US, "NY", "CA", "MA"; for GB, "ENG", "SCT", etc.)
    # The fields returned are raw data from the Geonames.org database, you can
    # get their names from Nearby::FIELDS.
    def get_place(options = {})
      query = TokyoCabinet::TDBQRY::new(@db)
      query.addcond("asciiname", TokyoCabinet::TDBQRY::QCSTREQ, options[:name])
      query.addcond("country_code", TokyoCabinet::TDBQRY::QCSTREQ, options[:country]) if options[:country]
      query.addcond("admin1_code", TokyoCabinet::TDBQRY::QCSTREQ, options[:region]) if options[:region]
      results = query.search
      results.empty? ? get_approximate_place(options) : results.collect { |i| @db.get(i) }
    end
    
    # Mainly used as a failover option for +get_place+, uses the alternate
    # names column from the geonames db.
    def get_approximate_place(options = {})
      query = TokyoCabinet::TDBQRY::new(@db)
      query.addcond("alternatenames", TokyoCabinet::TDBQRY::QCSTRAND, options[:name])
      query.addcond("country_code", TokyoCabinet::TDBQRY::QCSTREQ, options[:country]) if options[:country]
      query.addcond("admin1_code", TokyoCabinet::TDBQRY::QCSTREQ, options[:region]) if options[:region]
      query.search.collect { |i| @db.get(i) }
    end

    class << self

      # Create a TokyoCabinet database. Accepts the name of the new database,
      # and the file with the Geonames.org data.
      def create(db_file, data_file)
        db = TokyoCabinet::TDB::new
        db.open(db_file, TokyoCabinet::TDB::OREADER | TokyoCabinet::TDB::OWRITER |
          TokyoCabinet::TDB::OCREAT | TokyoCabinet::TDB::OTRUNC)

        File.open(data_file, "r") do |file|
          while line = file.gets do
            h = Hash[*Nearby::FIELDS.zip(line.split("\t")).flatten]
            # Add only cities and towns
            next if h["feature_class"][0,1] != "P"
            h.merge!("distance" => Nearby.haversine_distance(0, 0, h["latitude"], h["longitude"]).to_s)
            db.put(db.genuid, h)
          end
        end
        db.close
      end
    end

  end

  # Haversine sphere distance algorithm.
  def self.haversine_distance(lat1, lon1, lat2, lon2)
    dlon = lon2.to_f - lon1.to_f
    dlat = lat2.to_f - lat1.to_f
    dlon_rad = dlon * RAD_PER_DEG
    dlat_rad = dlat * RAD_PER_DEG
    lat1_rad = lat1.to_f * RAD_PER_DEG
    lon1_rad = lon1.to_f * RAD_PER_DEG
    lat2_rad = lat2.to_f * RAD_PER_DEG
    lon2_rad = lon2.to_f * RAD_PER_DEG
    a = (Math.sin(dlat_rad / 2)) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad / 2)) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    EARTH_RADIUS_KM * c
  end

end
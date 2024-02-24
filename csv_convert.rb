
require 'csv'

class ConvertIt
    # assumes both infile and outfile are defined
    def convert_from_to(infile, outfile)
      lines_to_write = []
      CSV.foreach(infile,  headers: true) do |row|
        simple_date = row['Created at'].split('T')[0]
        email = row['Email']
        full_name = row['Name']
        first_name = full_name.split(' ')[0]
        last_name = full_name.split(' ')[1]
        unless email.include? "readyset.io"
          lines_to_write << ["#{row['Name']}", first_name, last_name, "#{email}", "#{simple_date}", "cloud-signup", "#{row['Idp tenant domain']}"].to_csv
        end
      end

      File.open(outfile, "w") do |file|
        file.write "Name, First Name, Last Name, Email, Sign up date, Source, Company\n"
        lines_to_write.each do |line|
          file.write line
        end
      end
    end
end

if __FILE__ == $0
  converter = ConvertIt.new()
  unless ARGV[1] == nil || ARGV[0] == nil
    puts "Converting #{ARGV[0]} into #{ARGV[1]}"
    converter.convert_from_to ARGV[0], ARGV[1]
  else
    puts "You must provide an input and output file!"
  end
end
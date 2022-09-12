module UsersHelper
  def self.check_header(expected_header, csv_file)
    header = CSV.open(csv_file, 'r', encoding: 'iso-8859-1:utf-8') { |csv| csv.first }
    error_msg = ""

    if header.size != expected_header.size 
      error_msg = Messages::WRONG_COLUMN
    else
      (0..header.size - 1).each do |col_name|
        if (header[col_name] == nil || header[col_name].downcase != expected_header[col_name].downcase)
          error_msg = Messages::WRONG_HEADER
        end
      end
    end
    return error_msg
  end
end

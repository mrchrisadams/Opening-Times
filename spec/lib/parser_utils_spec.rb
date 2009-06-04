require File.dirname(__FILE__) + '/../spec_helper'

include ParserUtils

describe "extract_postcode" do

  it "should return nil if the string doesn't contain a valid postcode" do
    extract_postcode("").should be_nil
    extract_postcode("This is not the string you are looking for").should be_nil
  end

  it "should return the first valid postcode from a string in uppercase" do
    extract_postcode("SE15 5TL").should == "SE15 5TL"
    extract_postcode("se22 8hu").should == "SE22 8HU"
    extract_postcode("SW1a 0Aa").should == "SW1A 0AA"
    extract_postcode("SW1a 0Aa SE14 3LF").should == "SW1A 0AA"
    extract_postcode("SW1a 0Aa moved to SE14 3LF").should == "SW1A 0AA"
    extract_postcode("1 Virginia Street, London, E98 1TT").should == "E98 1TT"
    extract_postcode("<div class=\"addr\">Rawreth Lane<br/>Rayleigh<br/>SS6 9RN<br/><strong>Tel:</strong> 01268 654600</div>").should == "SS6 9RN"
  end

  it "should put a space after the postal district if once isn't already present" do
    extract_postcode("bn271jl").should == "BN27 1JL"
    extract_postcode("bn27 1jl").should == "BN27 1JL"
    extract_postcode("bn27  1jl").should == "BN27 1JL"
    extract_postcode("bn27 \n \t 1jl").should == "BN27 1JL"
  end

  it "should accept the following postcodes" do
    # postcodes I've had problems with in the past
    extract_postcode("E1W 1YY").should == "E1W 1YY"
    extract_postcode("EC3 9AU").should == "EC3 9AU"
    extract_postcode("SR7 7HN").should == "SR7 7HN"
  end

end

describe "extract_address" do

  it "should return the address and postcode" do
    address, postcode = extract_address("1 Virginia Street, London, E98 1TT")
    address.should == "1 Virginia Street, London"
    postcode.should == "E98 1TT"
  end

  it "should return the address and postcode, removing HTML" do
    address, postcode = extract_address("<div class=\"addr\">Rawreth Lane<br/>Rayleigh<br/>SS6 9RN<br/><strong>Tel:</strong> 01268 654600</div>")
    address.should == "Rawreth Lane, Rayleigh"
    postcode.should == "SS6 9RN"
  end

  it "should return the address and postcode, from test case ADSA" do
    address, postcode = extract_address("<div class=\"addr\">\nRooley Lane<br/>\nBradford<br/>\nBD4 7SR<br/>\n<strong>Tel:</strong> 01274 474000\n</div>\n")
    address.should == "Rooley Lane, Bradford"
    postcode.should == "BD4 7SR"
  end

end


describe "extract_phone" do

  it "should return an array of valid telephone numbers" do
    one, two = extract_phone("Tel: (020) 7500 3400 or fax: (020) 7500 3401")
    one.should == "(020) 7500 3400"
    two.should == "(020) 7500 3401"

    one, two = extract_phone("Tel: 01892 750 340 or fax: (0845) 60 60 60")
    one.should == "(01892) 750340"
    two.should == "(0845) 606060"
  end

  it "should return number in the correct format" do
    one, two = extract_phone("Tel: 02075003400 or fax: 0207 500 3401")
    one.should == "(020) 7500 3400"
    two.should == "(020) 7500 3401"

    one, two = extract_phone("Tel: 01892 750340 or fax: 0845 60 60 60")
    one.should == "(01892) 750340"
    two.should == "(0845) 606060"

    one, two = extract_phone("Tel: 020-7500-3400 or fax: (0207) 500 3401")
    one.should == "(020) 7500 3400"
    two.should == "(020) 7500 3401"
  end

  it "should return the correct geographic format" do
    extract_phone("02077327732").should == "(020) 7732 7732" # 020 London
    extract_phone("02087327732").should == "(020) 8732 7732" # 020 London
    extract_phone("02037327732").should == "(020) 3732 7732" # 020 London

    #TODO get some actual numbers for these areas
    extract_phone("02377327732").should == "(023) 7732 7732" # 023	Southampton and Portsmouth
    extract_phone("02477327732").should == "(024) 7732 7732" # 024	Coventry
    extract_phone("02877327732").should == "(028) 7732 7732" # 028 Northern Ireland
    extract_phone("02977327732").should == "(029) 7732 7732" # 029 Cardiff

    extract_phone("0113773277").should == "(0113) 773277" # 0113 Leeds
    extract_phone("0114773277").should == "(0114) 773277" # 0114 Sheffield
    extract_phone("0115773277").should == "(0115) 773277" # 0115 Nottingham
    extract_phone("0116773277").should == "(0116) 773277" # 0116 Leicester
    extract_phone("0117773277").should == "(0117) 773277" # 0117 Bristol
    extract_phone("0118773277").should == "(0118) 773277" # 0118 Reading

    extract_phone("0121773277").should == "(0121) 773277" # 0121 Birmingham
    extract_phone("0131773277").should == "(0131) 773277" # 0131 Edinburgh
    extract_phone("0141773277").should == "(0141) 773277" # 0141 Glasgow
    extract_phone("0151773277").should == "(0151) 773277" # 0151 Liverpool
    extract_phone("0161773277").should == "(0161) 773277" # 0161 Manchester
    extract_phone("0191773277").should == "(0191) 773277" # 0191 Tyne and Wear and Durham

    extract_phone("0169733277").should == "(016973) 3277" # 016973 Wigton
    extract_phone("0169743277").should == "(016974) 3277" # 016974 Raughton Head
    extract_phone("0169773277").should == "(016977) 3277" # 016977 Hallbankgate
  end

  it "should return the phone, from test case ADSA" do
    extract_phone("<div class=\"addr\">\nRooley Lane<br/>\nBradford<br/>\nBD4 7SR<br/>\n<strong>Tel:</strong> 01274 474000\n</div>\n").should == "(01274) 474000"
  end

  it "should return the phone from test case Farmfoods" do
  	extract_phone('<meta name="Telephone" content="+44 (0) 1236 456789" />').should == "(01236) 456789"
  end

  it "should return the phone from test case Sainsbury's" do
  	extract_phone('<p>612  -  614 Finchley Road<br />GOLDERS GREEN<br />London<br />NW11 7RX<br /><abbr title="Telephone">Tel</abbr>: 020 8458 6977<br /></p>').should == "(020) 8458 6977"
  end
end

describe "br_to_comma" do
  it "should turn html <br> <br/> and <br /> tags in to commas" do
    br_to_comma("Apple<br>banana<br/>pear<br />and grape").should == "Apple, banana, pear, and grape"
  end
end

describe "add_colon" do
  it "should add a colon within a time string" do
    add_colon("900") == "9:00"
    add_colon("0900") == "09:00"
    add_colon("1900") == "19:00"
    add_colon("9.00") == "9:00"
    add_colon("19.00") == "19:00"
    add_colon("9:00") == "9:00"
    add_colon("19:00") == "19:00"
  end
end

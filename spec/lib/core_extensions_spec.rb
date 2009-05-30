require File.dirname(__FILE__) + '/../spec_helper'

describe "slugify" do
  it "should make it lowercase" do
    "HELLO".slugify.should == "hello"
    "aBcD".slugify.should == "abcd"
  end  
  
  it "should remove apostrophes" do
    "Sainsbury's".slugify.should == "sainsburys"
    "O'Neil".slugify.should == "oneil"  
  end
  
  it "should remove spaces and non alpha numeric characters" do
    "foo().bar()".slugify.should == "foo-bar"
    "[woo[lA!*^%bIn£do".slugify.should == "woo-la-bin-do"
  end

  it "should turn & into 'and'" do
    "Fox & Sons".slugify.should == "fox-and-sons"
    "Lennon & McCartney".slugify.should == "lennon-and-mccartney"
  end
  
  it "should remove anything which causes hyphens at begining or end" do
    " war & peace ".slugify.should == "war-and-peace"
    "-oh-no-".slugify.should == "oh-no"
  end
  
  it "should return the same string if no changes made" do
    "Hello There!".slugify.slugify.should == "hello-there"
    "hello-there".slugify.should == "hello-there"
  end
  
  it "should be ok to be applied multiple times" do
    "Hello There!".slugify.slugify.should == "hello-there"
    "Hello There!".slugify.slugify.slugify.slugify.should == "hello-there"
  end

  it "should accept empty string" do
    "".slugify.should == ""
  end
end

describe "to_titlecase" do 
  it "should do nothing when nothing needs to be done" do
    "Hello There".to_titlecase == "Hello There"
  end
  
  it "should make the first letter of each word uppercase" do
    "hello there".to_titlecase.should == "Hello There"
  end

  it "should make uppercase words titlecase" do
    "HELLO THERE".to_titlecase.should == "Hello There"
  end  
  
  it "should make o'neil in to O'Neil, but not put's in to put'S" do
    "Let's get Mike's drink from o'neils pub".to_titlecase.should == "Let's Get Mike's Drink From O'Neils Pub"
    "o'neils o'Shane's O'CLOCK let's".to_titlecase.should == "O'Neils O'Shane's O'Clock Let's"
    "welcome to bo'ness".to_titlecase.should == "Welcome To Bo'Ness"
  end

  it "should deal with strange exceptions, such as McCartney" do
    "lennon & mccartney".to_titlecase.should == "Lennon & McCartney"
    "LENNON & MCCARTNEY".to_titlecase.should == "Lennon & McCartney"
  end
  
  it "should allow punctuation in words" do
    "oranges at half-time. I like (brackets)a,do you?a".to_titlecase.should == "Oranges At Half-Time. I Like (Brackets)A,Do You?A"
  end
     
end

describe "lstrip_commas" do
  it "should remove any amount of leading commas and white space" do
    ",test".lstrip_commas.should == "test"
    ", ,,, ,  , test".lstrip_commas.should == "test"
    ", \n\r\n,test".lstrip_commas.should == "test"
  end
  
  it "should return nil when nothing needs doing" do
    "test".lstrip_commas.should eql('test')
  end
end

describe "rstrip_commas" do
  it "should remove any amount of trailing commas and white space" do
    "test,".rstrip_commas.should == "test"
    "test,,, , ,    ,".rstrip_commas.should == "test"
    "test  , , \n , \r\n,".rstrip_commas.should == "test"
  end
    
  it "should return nil when nothing needs doing" do
    "test".rstrip_commas.should eql('test')
  end
end

describe "strip_commas" do
  it "should remove any amount of leading or trailing commas and white space" do
    ",test,".strip_commas.should == "test"
    ",  , ,,,  ,test,,, , ,    ,".strip_commas.should == "test"
    ",,  , \n\r\n\t , test  , , \n , \r\n,".strip_commas.should == "test"
  end

  it "should return nil when nothing needs doing" do
    "test".strip_commas.should eql('test')
  end
end

describe "squeeze_commas" do
  it "should reduce any amount of commas and whitespace to a singe comma followed by one space" do
    "test, , test".squeeze_commas.should == "test, test"
    "test, ,,, ,, , test".squeeze_commas.should == "test, test"
    ", ,  , , ,test ,,, , , ,,,test, ,  , , , ,".squeeze_commas.should == ", test, test, "
  end
  
  it "should return nil when nothing needs doing" do
    "test".squeeze_commas.should eql('test')
  end
end

describe "tidy_commas" do
  it "should reduce any amount of commas and whitespace to a singe comma between each term followed by one space" do
    "test, , test".tidy_commas.should == "test, test"
    "test, ,,, ,, , test".tidy_commas.should == "test, test"
    ", ,  , , ,test ,,, , , ,,,test, ,  , , , ,".tidy_commas.should == "test, test"
    ", ,  , , ,test ,,, , , ,,,test, ,  , ,Apple , ,".tidy_commas.should == "test, test, Apple"
  end
  
  it "should return nil when nothing needs doing" do
    "test".squeeze_commas.should eql('test')
  end
end

describe "tidy_text" do
  it "should turn line breaks, tabs etc in to white space" do
    "The\nowl\rand\tthe\r\npussycat".tidy_text.should == "The owl and the pussycat"
  end

  it "should remove leading and trailing commas and squeeze commas" do
    ", ,  , , ,test ,,, , , ,,,test, ,  , , , ,".tidy_text.should == "test, test"
  end

  it "should remove empty brackets with any amount of white space between" do
    "test() (   ) ( ) (test)".tidy_text.should == "test (test)"
    "test ( test".tidy_text.should == "test ( test"
    "test ) test".tidy_text.should == "test ) test"
  end
  
  it "should return nil when nothing needs doing" do
    "test".tidy_text.should eql('test')
  end
end

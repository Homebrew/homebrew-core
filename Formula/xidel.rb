class Xidel < Formula
  desc "Command line tool to download and extract data from HTML/XML pages or JSON-APIs, using CSS, XPath 3.0, XQuery 3.0, JSONiq or pattern templates. It can also create new or transformed XML/HTML/JSON documents."
  homepage "http://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  version "0.9.8"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  head "https://github.com/benibela/xidel.git", :branch => "master"

  depends_on "fpc" 
  depends_on "bash" 
  depends_on "openssl" => :recommended
  
  bottle :unneeded
  
  def install
    cd "xidel-#{version}-src/programs/internet/xidel" do
      system "bash", "build.sh"
      bin.install "xidel"
      man1.install "meta/xidel.1"
    end    
  end

  test do  
    cd "xidel-#{version}-src/programs/internet/xidel" do
      system "bash", "tests/tests.sh"
    end
  end
end

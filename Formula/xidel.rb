class Xidel < Formula
  desc "CLI XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "http://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  version "0.9.8"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  head "https://github.com/benibela/xidel.git", :branch => "master"

  bottle :unneeded

  depends_on "bash"
  depends_on "fpc"
  depends_on "openssl" => :recommended
  
  def install
    cd buildpath/"xidel-#{version}-src/programs/internet/xidel" do
      system "bash", "build.sh"
      bin.install "xidel"
      man1.install "meta/xidel.1"
    end
  end

  test do
    cd buildpath/"xidel-#{version}-src/programs/internet/xidel" do
      system "bash", "tests/tests.sh"
    end
  end
end

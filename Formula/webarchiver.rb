class Webarchiver < Formula
  desc "allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.9.tar.gz"
  sha256 "8ea826038e923c72e75a4bbb1416910368140a675421f6aaa51fd0dea703f75c"
  head "https://github.com/newzealandpaul/webarchiver.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d62bc4e985e7fe36519af669c626f5fdd3ef56b17ddaaba5d5fdad2505c8277d" => :sierra
    sha256 "63b8f54ff998596d2fab065f616f38d0c72dee9a48ae80a06c433a78813b4b11" => :el_capitan
    sha256 "0c86758734efe96b1f6d0fc8294691ff62e4d191d97312b614511d20b0f989f3" => :yosemite
    sha256 "404f9ffdf69b13cd1e89a51c331b4f8478400944eaf109a5d6f380dcf97bbddb" => :mavericks
  end

  depends_on :xcode => ["6.0.1", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "./build/Release/webarchiver"
  end

  test do
    system "#{bin}/webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match /Apple binary property list/, shell_output("file foo.webarchive", 0)
  end
end

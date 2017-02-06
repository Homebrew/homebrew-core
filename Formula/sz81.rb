class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "http://sz81.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  head "svn://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    sha256 "3953792f4c21d30885cd05560737d387df832072a4ae478f7f6eac1f5f1bb4e0" => :el_capitan
    sha256 "0c3feb15a6e52e5f6c54cadcb2775c6235b9b222d4415b276a003913b2e9e0c2" => :yosemite
    sha256 "2167f29e1aa3c866662790b359b89515506a45bf7514d5df77e490cf68d4d58b" => :mavericks
  end

  depends_on "sdl"

  def install
    args = %W[
      PREFIX=#{prefix}
      BINDIR=#{bin}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_match /sz81 #{version} -/, shell_output("#{bin}/sz81 -h", 1)
  end
end

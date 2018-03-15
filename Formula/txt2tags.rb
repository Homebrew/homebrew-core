class Txt2tags < Formula
  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://github.com/txt2tags/txt2tags/archive/2.6.tar.gz"
  sha256 "c87b911ac5cc97dd2fdb6067601cf4fbd0094a065f6b7a593142fa75e3a924c1"
  revision 1

  bottle :unneeded

  def install
    bin.install "txt2tags"
    man1.install "doc/English/manpage.man" => "txt2tags.1"
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match %r{<H1>Title</H1>}, File.read("test.html")
  end
end

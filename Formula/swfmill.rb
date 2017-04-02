class Swfmill < Formula
  desc "xml2swf and swf2xml processor"
  homepage "http://swfmill.org"
  url "http://swfmill.org/releases/swfmill-0.3.3.tar.gz"
  sha256 "f9e8529eed84962abf88c6457b59cbc6d230db068d1fdd977e7b234228beac96"
  revision 1

  bottle do
    cellar :any
    sha256 "5e141351c1aadf19e71d254ced8200698d0c07e8bbac21db938fc4734a494c0f" => :sierra
    sha256 "9c9674f4a986e2af30ffaa69c67276a43f0e0fcb4803a9463e66c63eb2398627" => :el_capitan
    sha256 "eee9695134c883a9348a7c5c1e66b32b7b01b8ef1f24069688c727eaf146ad50" => :yosemite
    sha256 "90cc5c0dcf27189d3f9cf0440c6a9e8ac4312d57c7afd60243f4496f1dd79541" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"

  def install
    # Use inreplace instead of a patch due to newlines
    # Reported usptream:
    # https://github.com/djcsdy/swfmill/issues/32
    inreplace "src/swft/swft_import_ttf.cpp",
      "#include <freetype/tttables.h>",
      "#include FT_TRUETYPE_TABLES_H"

    system "./configure", "--prefix=#{prefix}"
    # Has trouble linking against zlib unless we add it here - @adamv
    system "make", "LIBS=-lz", "install"
  end
end

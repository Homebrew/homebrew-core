class Swfmill < Formula
  desc "xml2swf and swf2xml processor"
  homepage "https://swfmill.org"
  url "https://www.swfmill.org/releases/swfmill-0.3.4.tar.gz"
  sha256 "514843cdacd1c95a1a8b60a3f4f4fc6559932fb270c6a0585ad5c3275da03589"

  bottle do
    cellar :any
    sha256 "38049fc1858f7002a7057bbf54501569c2e2f16b5c9dcb02d8972f0fb5d24adf" => :high_sierra
    sha256 "d30d4ede107e5392f29ac200977c98479474e6c191ea2afeaefe33c197d96f15" => :sierra
    sha256 "a4381d474ff02befed9fad1ff75aa7276c2da482ad5d39c9f46c5d133d340f22" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"

  def install
    # Use inreplace instead of a patch due to newlines
    # Reported usptream: https://github.com/djcsdy/swfmill/issues/32
    inreplace "src/swft/swft_import_ttf.cpp",
      "#include <freetype/tttables.h>",
      "#include FT_TRUETYPE_TABLES_H"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

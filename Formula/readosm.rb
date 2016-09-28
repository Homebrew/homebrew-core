class Readosm < Formula
  desc "Extract valid data from an Open Street Map input file"
  homepage "https://www.gaia-gis.it/fossil/readosm/index"
  url "https://www.gaia-gis.it/gaia-sins/readosm-1.0.0e.tar.gz"
  sha256 "1fd839e05b411db6ba1ca6199bf3334ab9425550a58e129c07ad3c6d39299acf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1c05e54fa7f490244443566a5d705152575511de1dfb7b8acf437b8483bedb79" => :sierra
    sha256 "039504a7e57854871753465a0a0a99c0ed12a3001c63a8cb8b075df7c9646778" => :el_capitan
    sha256 "36f2069bbc99e2cdd86749bfb2b6dee52ababbadd1d3b78f150787747e79578f" => :yosemite
    sha256 "de44f9c6d2e6a8cf7f5e27bcd7e8215c70b219a5d1d289fcb06f79ef9f2db54f" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lreadosm",
           doc/"examples/test_osm1.c", "-o", testpath/"test"
    assert_equal "usage: test_osm1 path-to-OSM-file",
                 shell_output("./test 2>&1", 255).chomp
  end
end

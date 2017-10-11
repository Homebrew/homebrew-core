class Readosm < Formula
  desc "Extract valid data from an Open Street Map input file"
  homepage "https://www.gaia-gis.it/fossil/readosm/index"
  url "https://www.gaia-gis.it/gaia-sins/readosm-1.1.0.tar.gz"
  sha256 "c508cde9c49b955613d9a30dcf622fa264a5c0e01f58074e93351ea39abd40ec"

  bottle do
    cellar :any
    rebuild 1
    sha256 "598852e6e9ce971d4f9280d91da37e69e416616a78a5322fa12f8e1455904891" => :high_sierra
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

class Readosm < Formula
  desc "Extract valid data from an Open Street Map input file"
  homepage "https://www.gaia-gis.it/fossil/readosm/index"
  url "https://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-1.1.0a.tar.gz"
  sha256 "db7c051d256cec7ecd4c3775ab9bc820da5a4bf72ffd4e9f40b911d79770f145"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?readosm[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "6f0a6b5f33f57429ed7d4608cf6819d85b829468abd7c954c381a599c8c73647" => :big_sur
    sha256 "bd41553e655ddd0efb25350087b8247102f308e40e20de46274a703beee4a1de" => :arm64_big_sur
    sha256 "2ea6c35bdfab9c28d9a5bc8a87e5306cbec6be17c26b1ad6f63ca70207a332a5" => :catalina
    sha256 "fcc1af52f7c13bfe4b3df0e1ca559ab79cee172c8941f51a335fb0fbb505027f" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Remove references to the Homebrew shims dir.
    %w[Makefile test_osm1 test_osm2 test_osm3].each do |file|
      inreplace "examples/#{file}", "#{HOMEBREW_SHIMS_PATH}/mac/super/", "/usr/bin/"
    end

    doc.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lreadosm",
           doc/"examples/test_osm1.c", "-o", testpath/"test"
    assert_equal "usage: test_osm1 path-to-OSM-file",
                 shell_output("./test 2>&1", 255).chomp
  end
end

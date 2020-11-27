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
    rebuild 1
    sha256 "ce08bf7cc440be683acc113a26dd0808c65c8139f0ea634c0655d6254ceb097e" => :big_sur
    sha256 "670c17d0b04569c8723b6bfab5440f3e23d60f31b891489619b760e4df1ccdf4" => :catalina
    sha256 "15d9f661d1d775dc76755db099d986c23002dc97edd65c675289f32129a8fd9c" => :mojave
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

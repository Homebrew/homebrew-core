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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0a497589a49224223074fbcec14b159fa14e3b1d9c5312035ca21026e6963e4c"
    sha256 cellar: :any,                 arm64_sequoia:  "08bbbc1a2839abc8e05b2e77ca2ccf248dc1ff4525ce893329d41306dfc33736"
    sha256 cellar: :any,                 arm64_sonoma:   "ec95a91f77c40f87229dab3be2be87e40354ac76c9517752524cccb44ae20219"
    sha256 cellar: :any,                 arm64_ventura:  "159a85b13ee27c3aec192f7cdfb26f58677890ca98768a1f9ab4a6843eefc791"
    sha256 cellar: :any,                 arm64_monterey: "938d6d422d3eb547b702f3bbeb547b1a6879f37782d72c705475a61fede5c780"
    sha256 cellar: :any,                 arm64_big_sur:  "bd41553e655ddd0efb25350087b8247102f308e40e20de46274a703beee4a1de"
    sha256 cellar: :any,                 sonoma:         "0db75c5f56cc0358622ea46bebd793fdc1417b318dd92fc377562aee2fe6070b"
    sha256 cellar: :any,                 ventura:        "9e6e4ee8ebb6ee681d5280fcf8e61e5ffbd0acb2bc2e6b97c6bf1bce32b37023"
    sha256 cellar: :any,                 monterey:       "37ac4df09be8730582ff8b11bf3480145eabdd697bf3335f80e7c6629b7bc74e"
    sha256 cellar: :any,                 big_sur:        "6f0a6b5f33f57429ed7d4608cf6819d85b829468abd7c954c381a599c8c73647"
    sha256 cellar: :any,                 catalina:       "2ea6c35bdfab9c28d9a5bc8a87e5306cbec6be17c26b1ad6f63ca70207a332a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cc269327efe3b1d43e2ef9040b17cd094fa6334f128ee9a18af4e5f58a23a4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba3380d75fdc00590269ff90d2f0b6d4daab79b63ded61df883cadb0f5d96c0"
  end

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Install examples but don't include Makefiles or objects
    doc.install "examples"
    rm doc.glob("examples/Makefile*")
    rm doc.glob("examples/*.o")
  end

  test do
    system ENV.cc, doc/"examples/test_osm1.c", "-o", testpath/"test",
                   "-I#{include}", "-L#{lib}", "-lreadosm"
    assert_equal "usage: test_osm1 path-to-OSM-file",
                 shell_output("./test 2>&1", 255).chomp
  end
end

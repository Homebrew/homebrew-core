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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b9cdc6c5c9194b216fe2df7e303cbd7831365325890ab9567933091b14849b29"
    sha256 cellar: :any,                 arm64_sequoia: "d4d433f3567a69df0994f2d34b5f99f6dec44c0bb970349a109395ad5b9c5fef"
    sha256 cellar: :any,                 arm64_sonoma:  "66da664066779580d86bdae1c90b82832266478a6cea81e290fc631ef0e348ff"
    sha256 cellar: :any,                 sonoma:        "1626ec8c44d88617a959525944a159132195750b514c4f92b3121b48bb0b8a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7257fd4fffdead318a4e24add70b3058aa1c3433391b621f2d6ccfbb35ed0745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f0db0c6070acbea09714988ab99e87fc6dd8610b8d07e7011a9b599608958b5"
  end

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

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

class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.13.0",
      revision: "c87a87c4053b01396fb1011f665910c696e27c91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "100102d237bd1f14a8f314566a1f376dfaa4ecc01623c88b3e73995c2d719253"
    sha256 cellar: :any,                 arm64_monterey: "9ca47afbb1e4142af64bbecaa643665fad5dd99ec5f20e2b2992493a2ff72564"
    sha256 cellar: :any,                 arm64_big_sur:  "2ff5616dc30f3b1b3c156ae82ffcd087a7b61b154d34fa3f74a28e0478006928"
    sha256 cellar: :any,                 ventura:        "466aa2c5724f5c1caf4c6572db769f376ef1924f24d378d2f0f5cfe9fee63c1e"
    sha256 cellar: :any,                 monterey:       "64029dcf891aced663a440a6d130c3ea81ba7f78ab11230b777839715d15c889"
    sha256 cellar: :any,                 big_sur:        "76adf4c08ed0b6c4e656a0a7c45a5a4864262a685f457c8095677d56f6ac9de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ca65f2877c8f580604418a3de4ec82d2f1b9dba12b9db5e50da84285041fc9"
  end

  depends_on "cxxopts" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_rf ["cxxopts", "rapidjson"]
      mkdir_p "cxxopts"
      ln_s Formula["cxxopts"].opt_include, "cxxopts/include"
      ln_s Formula["rapidjson"].opt_include, "rapidjson"
    end

    cd "src" do
      system "make"
    end
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end

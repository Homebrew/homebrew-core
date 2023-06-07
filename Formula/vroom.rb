class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.13.0",
      revision: "c87a87c4053b01396fb1011f665910c696e27c91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "859c96f16425d43095001a384482d808a9d742c4febceee0531a94f0e69262c4"
    sha256 cellar: :any,                 arm64_monterey: "7256965a8b0e0cb8cc03f7163a02ab20d5aa47a1c429bc1fc51969fd7b9945d7"
    sha256 cellar: :any,                 arm64_big_sur:  "7c9b175e5a1f2b11ab3e9a7be8f6ff834a5226962235f47d587e3860c482d4aa"
    sha256 cellar: :any,                 ventura:        "cd18b305b6dc45c8ef5eae74b8dd4e4e78f18aca39289f50e8a9df9349133041"
    sha256 cellar: :any,                 monterey:       "83c33eb3a050885e5454fa3e99bf994b8aef714c942700cff16c9d0703b37b51"
    sha256 cellar: :any,                 big_sur:        "184dce5a9f14d067c94912e868311be03a262c8e116f7845360de6b48edbe703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea99376fd729d0749d7823f55b0d1e63c3c277739d18b849a01860504a2ad7c"
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

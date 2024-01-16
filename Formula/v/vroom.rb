class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.14.0",
      revision: "1fd711bc8c20326dd8e9538e2c7e4cb1ebd67bdb"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6165a7cb235b8a0bc6e57479ec80257751698945e9a4b699115d3163fa1a0add"
    sha256 cellar: :any,                 arm64_ventura:  "0c57cf1a0b33c08327c768bf70580b3c9687fa18694466965b8d3f2e794f9093"
    sha256 cellar: :any,                 arm64_monterey: "e9748811a768dafc95d402f4626c04e0a63b69aa3e503a22c835334b4503d814"
    sha256 cellar: :any,                 sonoma:         "7cd025997ecb18d3d5fc35a953720fb96ce631ede626a9cb8bcf315187ce83c8"
    sha256 cellar: :any,                 ventura:        "788ecd2b38d2c912a0a573f7a0a7b2f7ac926dcf0ea9de61a1bb7e7ed8111d88"
    sha256 cellar: :any,                 monterey:       "bb59f660179205c05dc8ab2990b8fd3064be81b436f4b9ec12466906fa17c2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d4abf7176dba741db892b3708064ea7ffaa687892edd30dc0146d9144fe767"
  end

  depends_on "cxxopts" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@3"

  fails_with gcc: "5"

  # remove jthread usage, upstream PR ref, https://github.com/VROOM-Project/vroom/pull/1065
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/0cd72771fb79840a2a0ff64a58f0c18830665119.patch?full_index=1"
    sha256 "b271c6a7f27c17fbc5eb47c7b80bd697e29af8f631a4e27d68d00f9b08e9e9f9"
  end
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/1f631e5b84a4dd38289dd2ed01988ada2162f82c.patch?full_index=1"
    sha256 "65631ea4e4ecd7f73052fca34383a09756ec30f98390640d06d4a76b477861af"
  end

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

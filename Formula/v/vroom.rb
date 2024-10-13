class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.13.0",
      revision: "c87a87c4053b01396fb1011f665910c696e27c91"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "1c0df6c3a21095891a7cbf1508accd44318e83734b741b0ebc9aea5e99b61cd7"
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

  def install
    # fixes https://github.com/VROOM-Project/vroom/issues/997 , remove in version > 1.13.0
    inreplace "src/main.cpp", "throw cxxopts::OptionException", "throw cxxopts::exceptions::parsing"
    inreplace "src/main.cpp", "catch (const cxxopts::OptionException", "catch (const cxxopts::exceptions::exception"

    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_r(["cxxopts", "rapidjson"])
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

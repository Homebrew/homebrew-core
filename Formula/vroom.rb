class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.12.0",
      revision: "d3abd6b22fe4afc0daa64d6b905911999b12dcdd"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1495ca27a49a728916039d42c97f86f95d793f624cf3f8aa7eddf282a84c0f87"
    sha256 cellar: :any,                 arm64_big_sur:  "707ac7ece7545ed7818a66524c5efb19fe4d0fe14fd67fe1add5c2ec3d3bd451"
    sha256 cellar: :any,                 monterey:       "167d61c9e3cbbe0ee0318f810c69a317e91a02333041bf8474f946d67640d672"
    sha256 cellar: :any,                 big_sur:        "eb61354f6427688d143431e2e5b71a1d4af65f86d3ed5e2a88ef2bab70b4e48c"
    sha256 cellar: :any,                 catalina:       "b3932899fd64627e5fe686bdd356f7fcdab4dafcc330642b92c9d49e3ffa7c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72332ff619680bb368ff0472869c18dda1cf59b52b7b514d27c35171b8a5f3c7"
  end

  depends_on "cxxopts" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

  fails_with gcc: "5"

  # Fix build on macOS (https://github.com/VROOM-Project/vroom/issues/723)
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/f9e66df218e32eeb0026d2e1611a27ccf004fefd.patch?full_index=1"
    sha256 "848d5f03910d5cd4ae78b68f655c2db75a0e9f855e5ec34855e8cac58a0601b7"
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

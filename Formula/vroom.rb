class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.12.0",
      revision: "d3abd6b22fe4afc0daa64d6b905911999b12dcdd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9a7ee0f8a0259a58411b2fe63b3b3a22d7f01d96ee145af0fb66685decb8775"
    sha256 cellar: :any,                 arm64_big_sur:  "5c0936d8a7b8b2a87da21b81359f149a125cb9a4ae3185d494e451ec29545989"
    sha256 cellar: :any,                 monterey:       "03e44a724805d4d18a2867bbef8e5f68b02c2d8dc2db4746e1efa2b89eef2d69"
    sha256 cellar: :any,                 big_sur:        "defbedaba408253b4bc6ac2f6ac648efe79592ac6aed073f94ae217a030abc5c"
    sha256 cellar: :any,                 catalina:       "f547779b1b2a4ed66b8cc674807039d0de3e7c5f64000e019ab4010cbcb6becc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57dc7a44a6adef1dd566a0bd8bde4844923d83a7bcf2c761bdcdc1888e91b18f"
  end

  depends_on "cxxopts" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

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

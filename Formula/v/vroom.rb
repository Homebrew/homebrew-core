class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.15.0",
      revision: "43dd7d0b8b560431eb555bf335cf4797eb7343c4"
  license "BSD-2-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "70bb9f8f81057e5809842a2b9e713504ec779dbc04aaf6978cb7e1661b19245a"
    sha256 cellar: :any, arm64_tahoe:       "65665effda41316eca56f3cc55ea85b6a77f82bac89217361e6f160b0e026308"
    sha256 cellar: :any, arm64_sequoia:     "563ae010f0c39f498a37e323c08688adf02f33d8db8e74bd961d18db9a241168"
    sha256 cellar: :any, arm64_linux:       "806d645470b907cc7123c38535d92c3e4735fb38933c8217b8ceccc5a82437a9"
    sha256 cellar: :any, x86_64_linux:      "4ca927919c1330981dcb36606ab2df039dc9b0284e3d140ee424d31b76e134af"
  end

  depends_on "asio" => :build
  depends_on "cxxopts" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "openssl@4"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700 # for std::jthreads
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  # Apply open PR to fix missing include
  # PR ref: https://github.com/VROOM-Project/vroom/pull/1333
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/3bd437aa5951040593d535336a3d7cf86b6ac405.patch?full_index=1"
    sha256 "f9681c0d96265435e3b15477ec9471116159716a2a868b33e4d46eb1009cd1dd"
    type :backport
    resolves "https://github.com/VROOM-Project/vroom/pull/1333"
  end

  deny_network_access!

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_r(["cxxopts", "rapidjson"])
      mkdir_p "cxxopts"
      ln_s formula_opt_include("cxxopts"), "cxxopts/include"
      ln_s formula_opt_include("rapidjson"), "rapidjson"
    end

    files = %w[
      src/routing/http_wrapper.h
      src/utils/input_parser.cpp
      src/utils/output_json.cpp
      src/utils/output_json.h
    ]
    inreplace files, "../include/rapidjson/include/rapidjson", "rapidjson"

    system "make", "-C", "src"
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

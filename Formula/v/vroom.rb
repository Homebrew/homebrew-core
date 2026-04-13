class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.15.0",
      revision: "43dd7d0b8b560431eb555bf335cf4797eb7343c4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8b5b8201eb2a208ccf15450bc41fe368b6370b99f396b42fe8ca86b243ac6b7"
    sha256 cellar: :any,                 arm64_sequoia: "4ef7a45d8ddb7fa202817b2abe984bd735c8af3e72ecda4a616ffa750c440def"
    sha256 cellar: :any,                 arm64_sonoma:  "167932e93c1bbb4bac127ab8cbbbe3e5ef540ed38c24bac411afecaac39a6fce"
    sha256 cellar: :any,                 sonoma:        "368891c8f744c684cb6a247453d24c00669a4ee2f74087dd83f33b77ede9e46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4843c6585ed3a4f3577343def96dbb5b642310a295c44960bafaeafd7d7909f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf83b02f2274b91d4cda4ab204050768833b00a8db87b3f85744742e271bf20"
  end

  depends_on "asio" => :build
  depends_on "cxxopts" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "openssl@3"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700
  end

  on_linux do
    depends_on "gcc" # TODO: remove and rebuild bottle on Ubuntu 24.04
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
  end

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_r(["cxxopts", "rapidjson"])
      mkdir_p "cxxopts"
      ln_s Formula["cxxopts"].opt_include, "cxxopts/include"
      ln_s Formula["rapidjson"].opt_include, "rapidjson"
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

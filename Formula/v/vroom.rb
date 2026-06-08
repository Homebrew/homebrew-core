class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.15.0",
      revision: "43dd7d0b8b560431eb555bf335cf4797eb7343c4"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7744afdfd4869482feafc33eb89ec4a3879aa0834e7e42a89ad9778ca61bd769"
    sha256 cellar: :any, arm64_sequoia: "0b0d31f32ec9ef559d948f558527632afcc5388456569801e98e3647cb82ec66"
    sha256 cellar: :any, arm64_sonoma:  "4cf49df44fd7999cc2083a3e526ea48daa0aa2cb3662e3e8a552f94c2d655a39"
    sha256 cellar: :any, sonoma:        "1a3b3a8de929a276843f4a331c001dbf2b05b0ed8a3ab252913917ec54c3108e"
    sha256 cellar: :any, arm64_linux:   "a2a1d04eb068ee7dfae180aafe0dab114be21a4216e6cc23da1a7a5f3d7e4c31"
    sha256 cellar: :any, x86_64_linux:  "ae5cf02e2d7babb46ded692739e45eff866e7bfee3900fefba3dc42a402fea40"
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

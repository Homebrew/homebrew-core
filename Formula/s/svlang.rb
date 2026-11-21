class Svlang < Formula
  desc "SystemVerilog compiler and language services"
  homepage "https://sv-lang.com/"
  url "https://github.com/MikePopoloski/slang/archive/refs/tags/v12.2.tar.gz"
  sha256 "29c8dee801e489e10f84ebc8a65b641bbcee18614fd183223b35e85c2461b6ab"
  license "MIT"
  revision 1
  head "https://github.com/MikePopoloski/slang.git", branch: "master"

  bottle do
    manifest_sha256 "c172a881bca20ea2b6b02ad8fd7c7da0a703b0723266bcfa74ff0aa3713c87cb"
    sha256 cellar: :any, arm64_golden_gate: "70575f5208973121248520ea1d6c21e419923744e96a1c6d7769062e9e0be7b2"
    sha256 cellar: :any, arm64_tahoe:       "0373fd04590509609318c5c41162a0ac5b4a320fee0d60d690fb76eb6b952acd"
    sha256 cellar: :any, arm64_sequoia:     "68f7e159c94e32fe5f9fa4bc9ecd857d5e793bad49dd113b52dcb9d40f05e0a7"
    sha256 cellar: :any, arm64_linux:       "f1365b0f10f6d210821aad87cfbe41f65ed955ed53f79c899f400a39dd54cdec"
    sha256 cellar: :any, x86_64_linux:      "70584901a3f5345f4db69279185692ee474bdc5c7feb555f74697ad6a4b423de"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "mimalloc"
  depends_on "tomlplusplus"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  # Needs std::views::join, missing from the macOS 14 SDK's libc++
  fails_with :clang do
    build 1600
    cause "needs std::views::join, missing from the macOS 14 SDK's libc++"
  end

  deny_network_access!

  def install
    args = %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DSLANG_INCLUDE_TESTS=OFF
      -DSLANG_INCLUDE_TOOLS=ON
      -DSLANG_USE_SYSTEM_BOOST=ON
      -DSLANG_USE_SYSTEM_FMT=ON
      -DSLANG_USE_SYSTEM_TOMLPLUSPLUS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.sv").write <<~SV
      module top;
        initial begin
          $display("Hello, Slang!");
        end
      endmodule
    SV
    system bin/"slang", "test.sv"
  end
end

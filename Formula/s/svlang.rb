class Svlang < Formula
  desc "SystemVerilog compiler and language services"
  homepage "https://sv-lang.com/"
  url "https://github.com/MikePopoloski/slang/archive/refs/tags/v12.2.tar.gz"
  sha256 "29c8dee801e489e10f84ebc8a65b641bbcee18614fd183223b35e85c2461b6ab"
  license "MIT"
  revision 1
  head "https://github.com/MikePopoloski/slang.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a24254d329ba0244b4b25213e53f595d502559f42b2e4951b0541b6936fc48d"
    sha256 cellar: :any, arm64_tahoe:       "0464cd9ced22bb3f506346d05bcfb77c1bebdede8ccea02166323d2adac55a17"
    sha256 cellar: :any, arm64_sequoia:     "f32ccf10886678458a5576746047954dbb3e756cffe86aefc4c2ca6d70d9f5ba"
    sha256 cellar: :any, arm64_linux:       "dc0df10edfafde6a69e84be4313c31f5a64c717ba58a9bab892e8be92b882cd5"
    sha256 cellar: :any, x86_64_linux:      "c4a8b4feec6b6223822b451c5d21aba4bfc886c146610574565d215a7479296e"
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

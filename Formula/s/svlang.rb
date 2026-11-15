class Svlang < Formula
  desc "SystemVerilog compiler and language services"
  homepage "https://sv-lang.com/"
  url "https://github.com/MikePopoloski/slang/archive/refs/tags/v12.1.tar.gz"
  sha256 "e7454393956ef0f3e9bbcac27f7de473e11e1fd7be125c3009f1f2bfeddf0358"
  license "MIT"
  head "https://github.com/MikePopoloski/slang.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3d455629527667ce6c980eaba175abc82da079ff321cff8b5cc26e3fab33128d"
    sha256 cellar: :any, arm64_tahoe:       "29f7213b37e2075e7252dba70c28b568b691edec95f5c4e965ee1f4bc75fb050"
    sha256 cellar: :any, arm64_sequoia:     "b7697e40b8823d17d0ca95aa567a84505a4a606127d15e587d9ca310cefe9292"
    sha256 cellar: :any, arm64_linux:       "d14b5b2ec2455521b163b84cc1f0599c7536f412f42ed592ca7779e73eb60dde"
    sha256 cellar: :any, x86_64_linux:      "58b38149cbee7fc72cfbead49cf8feeaf937274cdeef5d8eace1de25cb278039"
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

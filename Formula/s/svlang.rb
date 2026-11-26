class Svlang < Formula
  desc "SystemVerilog compiler and language services"
  homepage "https://sv-lang.com/"
  url "https://github.com/MikePopoloski/slang/archive/refs/tags/v12.2.tar.gz"
  sha256 "29c8dee801e489e10f84ebc8a65b641bbcee18614fd183223b35e85c2461b6ab"
  license "MIT"
  revision 1
  head "https://github.com/MikePopoloski/slang.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "aa5480c164b4506947e5c55f9ea4b70cab85f8c80220abc6ac3eb46b306c0b1b"
    sha256 cellar: :any, arm64_golden_gate: "9d0849c6f22e6f2f2f24676d123fe50e004ffe7592723dd6e6e82153063a42e8"
    sha256 cellar: :any, arm64_tahoe:       "19530b3e481a6e6f4d7b751072729002d34b077b9c9254531f52334284905a52"
    sha256 cellar: :any, arm64_sequoia:     "4267fb30cf46d0854e2b6204ed94b247dc386f93eb66cec7f0f1122f688550b6"
    sha256 cellar: :any, arm64_linux:       "b8b64fe35535174a6662e29a4655e19cae86f600d04b713b808a08f399b77e80"
    sha256 cellar: :any, x86_64_linux:      "f5f5a9634355b50d7e8c2c6b562912a05983c0efda62d2abc2fd1bc171d6e6af"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "tomlplusplus" => :build
  depends_on "fmt"
  depends_on "mimalloc"

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
      -DBUILD_SHARED_LIBS=ON
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

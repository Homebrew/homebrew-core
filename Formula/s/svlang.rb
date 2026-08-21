class Svlang < Formula
  desc "SystemVerilog compiler and language services"
  homepage "https://sv-lang.com/"
  url "https://github.com/MikePopoloski/slang/archive/refs/tags/v11.0.tar.gz"
  sha256 "50676d5a9adbefb97d266a4b174e6b0513901afd5ac57a6cdfea0a61149c3704"
  license "MIT"
  head "https://github.com/MikePopoloski/slang.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5182e41983044275fc167af043d81ea8d202821017f8417d094a9c94f910600"
    sha256 cellar: :any, arm64_sequoia: "87aa125dca574a01827c92420c92b15a081597e4c03c1b2e09cb788919c91d79"
    sha256 cellar: :any, arm64_sonoma:  "dc82f99aa17fdd9b112627b0c20134a3406efe2fb607ef16b58519f777f6f7af"
    sha256 cellar: :any, sonoma:        "8841904fbbe822758474f70428b8c3978448b9b1b0a3e96c1dcbe2883bc5336d"
    sha256 cellar: :any, arm64_linux:   "5c4e0748b60d9749502143b043f1d0e639f98aa476ed654b46ffe620387bb6e3"
    sha256 cellar: :any, x86_64_linux:  "b960c02e941ea96322f3540dd07c271537edaf6c05f44db4f62e276b7db304ee"
  end

  depends_on "cmake" => :build
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

  def install
    # `fmt/core.h` stopped pulling in `fmt::format` in fmt 12.2, remove in next release
    ENV.append_to_cflags "-DFMT_DEPRECATED_HEAVY_CORE"

    args = %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DSLANG_INCLUDE_TESTS=OFF
      -DSLANG_INCLUDE_TOOLS=ON
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

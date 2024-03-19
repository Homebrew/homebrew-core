class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ziglang.org/download/0.11.0/zig-0.11.0.tar.xz"
  sha256 "72014e700e50c0d3528cef3adf80b76b26ab27730133e8202716a187a799e951"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2045088ae2dc8f88dcb6e10a508d677a622e01c0082e9eb4def0e4629d968028"
    sha256 cellar: :any,                 arm64_ventura:  "c86f263129502db9b998b279c79ba373a6d9e88e2e47e4492ed696a004d21980"
    sha256 cellar: :any,                 arm64_monterey: "fbc4211c5beacb7cc1c7c36ba1db931492fb3289bbcbc2b085f0e5af6ab40659"
    sha256 cellar: :any,                 arm64_big_sur:  "472a2c08984811317234c134d7347266ce8e30c24ef75076f397d8b50b474e3b"
    sha256 cellar: :any,                 sonoma:         "81b7a46ac4198743b53d92e02f20215a6505feb33c753ee6618528d3fbfc3ed6"
    sha256 cellar: :any,                 ventura:        "9adbe95444f3b648d1cd2ae2f8dc07891f7527cb1da369fd3f5db6c75ace1079"
    sha256 cellar: :any,                 monterey:       "172f93925e39207a580e1d5a71b211415364e8756e0a02386c9e5f6be99b1ea5"
    sha256 cellar: :any,                 big_sur:        "00002da55679b70ef280b06f67154a449876c5ab08b13cbdaa261bacca07fa74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a108d8abb0c31301daab3230db5537136281309291fcba3df62817fbbb32c13"
  end

  depends_on "cmake" => :build
  # Check: https://github.com/ziglang/zig/blob/#{version}/CMakeLists.txt
  # for supported LLVM version.
  # When switching to `llvm`, remove the `on_linux` block below.
  depends_on "llvm@16" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # `llvm` is not actually used, but we need it because `brew`'s compiler
  # selector does not currently support using Clang from a versioned LLVM.
  on_linux do
    depends_on "llvm" => :build
  end

  fails_with :gcc

  def install
    # Make sure `llvm@16` is used.
    ENV.prepend_path "PATH", Formula["llvm@16"].opt_bin
    ENV["CC"] = Formula["llvm@16"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm@16"].opt_bin/"clang++"

    # Work around duplicate symbols with Xcode 15 linker.
    # Remove on next release.
    # https://github.com/ziglang/zig/issues/17050
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_STATIC_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end

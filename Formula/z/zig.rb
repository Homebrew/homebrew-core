class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.13.0/zig-0.13.0.tar.xz"
  sha256 "06c73596beeccb71cc073805bdb9c0e05764128f16478fa53bf17dfabc1d4318"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0cd64ccf3ff42f7857000ead7b3b2f09b78c2d4e1e0f661f8f4cb6552b6ad88e"
    sha256 cellar: :any,                 arm64_sonoma:   "e2fdab9f70dba65551d21e6e9fc47d98336bcdb52658ff3f7799ad244aa2f500"
    sha256 cellar: :any,                 arm64_ventura:  "09cbcd8fdc15b0c5cdcbdecd2f0e42337a2ddac0070b50189fb02e5db1942633"
    sha256 cellar: :any,                 arm64_monterey: "2f197b24ce0a0d7167eacf89314407ef21103e963916c05c9a094d79d152ecc4"
    sha256 cellar: :any,                 sonoma:         "193e35179c6695aee629a8551920237cf3c94a8a8853b9edf61e91ac7ba709e2"
    sha256 cellar: :any,                 ventura:        "dda3491dea9cdda74d5ab8ef63a38f88ad1e73e1d7ec58c4e54333e9a3333b54"
    sha256 cellar: :any,                 monterey:       "ea39859d4c94d9a3b5c03d5faa7552275ad74d13d24c3ea558ae3f6397a9879e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca207335ca7208dbe6198f0c12d593f7c8251457e924bc05f3cd1875874cc3af"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3" # Remove when using versioned LLVM
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    if llvm.versioned_formula? && deps.any? { |dep| dep.name == "z3" }
      # Don't remove this check even if we're using a versioned LLVM
      # to avoid accidentally keeping it when not needed in the future.
      odie "`z3` dependency should be removed!"
    end

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
    system bin/"zig", "build-exe", "hello.zig"
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
    system bin/"zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end

class ZigAT015 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.15.2/zig-0.15.2.tar.xz"
  sha256 "d9b30c7aa983fcff5eed2084d54ae83eaafe7ff3a84d8fb754d854165a6e521c"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(0\.15(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5d6f38219bd78bf111b00a640d4d6aadb75a480da61fa8ceb947a9ae61ef1eaf"
    sha256 cellar: :any, arm64_tahoe:       "7bb95027a7c58e87b0849908d70acc21c52d457eff743804171e0ea51568d349"
    sha256 cellar: :any, arm64_sequoia:     "6642afc23c2a5205fd0c05955d624ece59896d0841c675ea826c1ff7b2ef36c2"
    sha256 cellar: :any, arm64_linux:       "87a486ef22d5d089d96056632350c2fb6b486a1c00d7ac89e54ecd4090df9fcb"
    sha256 cellar: :any, x86_64_linux:      "00f3684955c20dee27f676290be00f5b5ed3ced66da204b1c775b6b74e00a905"
  end

  keg_only :versioned_formula

  # Unsupported since Zig 0.16 was released on 2026-04-13, but we are
  # giving an extra 1 year for dependents to migrate to newer Zig
  deprecate! date: "2027-04-15", because: :unsupported
  disable! date: "2028-04-15", because: :unsupported

  depends_on "cmake" => :build
  depends_on "lld@20"
  depends_on "llvm@20"

  on_macos do
    depends_on "zstd"
  end

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Fix linkage with libc++.
  #   https://github.com/ziglang/zig/pull/23264
  # Fix max_rss
  #   https://github.com/Homebrew/homebrew-core/issues/252365
  patch do
    file "Patches/zig/0.15.patch"
    type :unofficial
  end

  # Fix `INFINITY` with macOS 27 SDK `math.h`.
  #   https://github.com/llvm/llvm-project/pull/164348
  patch do
    file "Patches/zig/0.15-float-infinity-nan.patch"
    type :unofficial
  end

  def install
    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    args = ["-DZIG_SHARED_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{Hardware.zig_cpu(ENV.effective_arch)}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
          try std.fs.File.stdout().writeAll("Hello, world!");
      }
    ZIG
    system bin/"zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    arches = ["aarch64", "x86_64"]
    systems = ["macos", "linux"]
    arches.each do |arch|
      systems.each do |os|
        system bin/"zig", "build-exe", "hello.zig", "-target", "#{arch}-#{os}", "--name", "hello-#{arch}-#{os}"
        assert_path_exists testpath/"hello-#{arch}-#{os}"
        file_output = shell_output("file --brief hello-#{arch}-#{os}").strip
        if os == "linux"
          assert_match(/\bELF\b/, file_output)
          assert_match(/\b#{arch.tr("_", "-")}\b/, file_output)
        else
          assert_match(/\bMach-O\b/, file_output)
          expected_arch = (arch == "aarch64") ? "arm64" : arch
          assert_match(/\b#{expected_arch}\b/, file_output)
        end
      end
    end

    native_os = OS.mac? ? "macos" : OS.kernel_name.downcase
    native_arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    assert_equal "Hello, world!", shell_output("./hello-#{native_arch}-#{native_os}")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    C
    system bin/"zig", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c")

    return unless OS.mac?

    # See https://github.com/Homebrew/homebrew-core/pull/211129
    require "utils/linkage"
    library = "/usr/lib/libc++.1.dylib"
    assert Utils.binary_linked_to_library?(bin/"zig", library), "No linkage with #{library}!"
  end
end

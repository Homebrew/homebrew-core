class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "ee4983e594610e185ded3b798fbbde60f04cceb73f92c4593d26b9add17e1b5d"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "071e9be36774b2e08cb45920451b2080d293a4f78efd653ca228f00a0f24d9a8"
    sha256 cellar: :any, arm64_sequoia: "d2a9d270382a0c41ab564bdf3676dd71feeac26ca324875b9e522d02fd0fe5f0"
    sha256 cellar: :any, arm64_sonoma:  "57eea592447a0ca8fb1f4f8524d5c868aa527f524b73e4432586d435d137a2a4"
    sha256 cellar: :any, sonoma:        "b85def5c9a058ef3edf88deaace5144d1291fd516c8df03a12f5fc718a78f476"
    sha256 cellar: :any, arm64_linux:   "9d969e4cfc2876b0bde8c7aa1f013265f84f5786f0ac3faeb760a71410b963c1"
    sha256 cellar: :any, x86_64_linux:  "6b30ea4460d356d2708fda38e57720ac1a984ae1d6a5c8ec3233bd2c0d8bfc62"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat" => :test
  end

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append_to_rustflags "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "zpipe.c" do
      url "https://raw.githubusercontent.com/trifectatechfoundation/zlib-rs/refs/tags/v0.6.2/libz-rs-sys-cdylib/zpipe.c"
      sha256 "4fd3b0b41fb8da462d28da5b3e214cc6f4609205b38aaee1e20524b57124f338"
    end

    testpath.install resource("zpipe.c")
    ENV.append_to_cflags "-I#{formula_opt_include("zlib-ng-compat")}" if OS.linux?
    system ENV.cc, "zpipe.c", *ENV.cflags.to_s.split, "-L#{lib}", "-lz_rs", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end

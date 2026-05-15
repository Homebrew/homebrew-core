class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "a705fba2e98dc82fc2993a6572d3a200d41cbd070a52d33897927a4cce17d793"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93f8170aa05a16177d7a9b9e82935e1a6f4d821ee8a21c50ac75b9dcd390ffc1"
    sha256 cellar: :any,                 arm64_sequoia: "c449fe85176de2ae96715abfc2cc9c873314ecb781e6daf54072f5c5e38db1fa"
    sha256 cellar: :any,                 arm64_sonoma:  "26dc11f0ed9e39e02d334b0522033bdff751cc4e6951a9e7700f8646689e6ed7"
    sha256 cellar: :any,                 sonoma:        "adf8703625fe9399c277e0ec25f4d847b33454e1c70041cc8ed1325c32aed43b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64bdb816774fae459ba97b7929253c33c2fd143bb02cc63acf09ba51ecff7c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b759889976a07c698067025d0eb02d3cea042f433497645349566a7d4c0dffed"
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
    ENV.append_to_cflags "-I#{Formula["zlib-ng-compat"].opt_include}" if OS.linux?
    system ENV.cc, "zpipe.c", *ENV.cflags.to_s.split, "-L#{lib}", "-lz_rs", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end

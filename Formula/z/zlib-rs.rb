class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "e909a4fe6a67362e5a0db67114b69496a4572c0b99c26e7542638ec003fc11b2"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c2061235d10213b7315009e9a6bbce746ac30dca7470eab0bf509703f427ccd"
    sha256 cellar: :any, arm64_sequoia: "c8dbda0aacd5a18f983870c02ed8baf4f1c073910ecb3223197374c8ffd24964"
    sha256 cellar: :any, arm64_sonoma:  "4e280b52c556d00bfe8af8b098b39bbd7bf1e647ac302152726483135b8978c4"
    sha256 cellar: :any, sonoma:        "94134bea1256be9ec8dfbe88b437c0c30693b5ac01c1fb089d9794d0450a5501"
    sha256 cellar: :any, arm64_linux:   "48b5369f90d3cf70a4de57bdb032999ba638e48fd9ae7b14c490201f219aa9e6"
    sha256 cellar: :any, x86_64_linux:  "88350ae0fbcae6dd6ab49fda2a369226f85abae570dd6755c33bc977343049cf"
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

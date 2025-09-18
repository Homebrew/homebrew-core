class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "38f6d0ebc0e00fe4df696af049d70de99cb79a781611167ff1f0fd2b78feb0c4"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "859ac57d9978301b445b61052eecf2109c7ade9e333a6765b5b5e3a8807b73d9"
    sha256 cellar: :any,                 arm64_sequoia: "4a51ae18c3fc7fb801cbb64a391e28e5dc022383fc412f890f3385897a3cd512"
    sha256 cellar: :any,                 arm64_sonoma:  "8829610f18363a0665da0b4c01a4ecc547846bdf2cc013b85490c93d37def924"
    sha256 cellar: :any,                 arm64_ventura: "337ddb0376831e118ffbc5b95c206fdf848e0bf92b4e4031dd30540901aa34e2"
    sha256 cellar: :any,                 sonoma:        "83ed86d834273ce4b8979995ac678020467166326f3cc1e4a5bb28a6c3f3625a"
    sha256 cellar: :any,                 ventura:       "cec9dd6565a31440586ca06006c3c79077d7f45d578080434ea90897037cccda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33a4e39b5f3eaa80dd6062299cb83afe3620c78371b2c73322bfaf45723d326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f8c82d180bd8925166564577cc77347b984f160a147e9b59199ebbcb2aeb36"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  uses_from_macos "zlib" => :test

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append_to_rustflags "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "test_artifact" do
      url "https://zlib.net/zpipe.c"
      version "20051211"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    testpath.install resource("test_artifact")
    ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}" if OS.linux?
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lz_rs"
    system "make", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end

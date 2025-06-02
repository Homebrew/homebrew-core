class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a5ef58c30220173b44c1304a9e367ec8fd6ac03c6c93ca41fc24b4837754ed1a"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14055c1717edc6ed5c02400fb796ec92358e860e89769fbe3cffbe535370e9e2"
    sha256 cellar: :any,                 arm64_sonoma:  "e22c071ad8235312de8088a945cd8d4fd3e70d817e8a37b56f20446e1f2bd913"
    sha256 cellar: :any,                 arm64_ventura: "26806a408c5db4382b74e235832d67df54cfbc196c295b4d3d3360e468ba3160"
    sha256 cellar: :any,                 sonoma:        "8e009873fd7b806d61ee3adbf21b28a9c4c6f8922b00a4f15011496061bac822"
    sha256 cellar: :any,                 ventura:       "845797bf7b2fc8f47cfc8fb6367b763145879706c17dbaf47bd1e8a682dfa3ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce7248f219ceaf414ad7fa7510dccb82ed4e24d39a30beec24a15517db57a27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3eaaf5a413bc07ac46e88f40551f0f8ff40a88461526e0fa04587541607319b"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  uses_from_macos "zlib" => :test

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append "RUSTFLAGS", "-Cllvm-args=-enable-dfa-jump-thread"
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

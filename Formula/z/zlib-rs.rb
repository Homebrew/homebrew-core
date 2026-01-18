class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "719ac9b3aa5baf6ceb5da1885364c2b9a98194b51f00d06573bf9e70c765d847"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3fb41a7fb7d44d78e1d201401c0a1087891d2d3e14b96c6d68c63461e7e0f35"
    sha256 cellar: :any,                 arm64_sequoia: "2e7cceb896f079f4650719be93edc19ca6545ea397e3d1598253272bc29d219d"
    sha256 cellar: :any,                 arm64_sonoma:  "59eb8629c7b8aa056fdcf2b530ab7f990f25e77723634c025da087b3d50926ad"
    sha256 cellar: :any,                 sonoma:        "c87ca7e1ea31e68e942578edf9c2005f004ed1d843524bf583030dedd15bed5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40098f2033d703073e07e68a45250ed5b1967c461998b7f40dbccfa207289e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50c0354ac8447d66a9dc9962d881f5680a5c69358454828cf3ee0bc70d26a690"
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

class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "270dedde7e1cd63e7a743a520a74b92e82aaf02a2cb7e5e461364f58a03cc720"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38915205b01501c510264cd8aefb8da5d750efcab57330393899815bb4360784"
    sha256 cellar: :any,                 arm64_sonoma:  "497eb4619f5bb32a1aafdc3810a27c2d9383cc7264d125e77815a1cf815ebd28"
    sha256 cellar: :any,                 arm64_ventura: "77a3b525b3b45bd8ce128ccf6cede288fde8b69eb794035b59b4483774c633c0"
    sha256 cellar: :any,                 sonoma:        "12df87dd4328d80c6fc09998b02c00ae4394a1819ec020e6a5942e8fab530839"
    sha256 cellar: :any,                 ventura:       "000a275cbb2adfc476975f56f7c30cac63f7c3b7ec3bf1ced936c77db8a1b08d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b14ecc2ba8a86802a9b80e44e21015d508c475f996615f59ebda11d4dd6271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7eac09031e10b77fb45dfa2ee6826df56bf79aa356a5e845418aa8a0f9de26"
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

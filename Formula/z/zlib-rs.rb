class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "b811e5de0e8bd43607b164a88f6bae063dd2f19b7d25e588e47f3c32e983322e"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05608689e545409cfdb2ef017f5d5dbf76a48fbcde892cf4af8fa876b90e3259"
    sha256 cellar: :any,                 arm64_sequoia: "bacd733a5f7e9a6f643b8657811e9aad01e4db23ea403818feda82bc7ba6d543"
    sha256 cellar: :any,                 arm64_sonoma:  "b7650499f87fece075c77f0c364078b87b5d2119b6a04fc3aa2d9b26e0d8065e"
    sha256 cellar: :any,                 sonoma:        "13e5403c4a0516b071e267ae161745392accbfcf611e52f5c81e3d993d550b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f44a228025a10f47f0814c3d58dae3ddc1ce53fbb1cbdf7108ef223bbca417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d99066b0e9df517527dd4b0e0c7f669886e485fb879ca864c9fdafd15840ac"
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

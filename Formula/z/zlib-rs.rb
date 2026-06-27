class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "4306193d8c9b9ef96f04739cbf4e04b09707ad8ca14237fa8096314d677e342b"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca72ee834d7e1a212ede5810a4b23a42c5d4c2c3640e0bea89f6a7eae1f739ad"
    sha256 cellar: :any, arm64_sequoia: "71d7b402d110ff83d79b60d30e7e38caae99b375705ff9a0c3887e20dee0069e"
    sha256 cellar: :any, arm64_sonoma:  "679a2f3e5cfc645b5ff3271e93eb95bcaad74d6947b5a574804b15caf4a5bc7c"
    sha256 cellar: :any, sonoma:        "c1f8ac8622f0a85da9a0600999b96e104b96dc15baf5e175e3e1235836c37011"
    sha256 cellar: :any, arm64_linux:   "12ab8be89ef7329bb6b7aeea45ad641405c38cc5a3c20c2de4e05ee1083099eb"
    sha256 cellar: :any, x86_64_linux:  "81276adf8de2cc97074b46484865aff7445e239b7eec6c05115ffb5e944368d6"
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

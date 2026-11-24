class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "3e0ede4c8cb9d8a050d1ab9d22a1cac11c8576beb894b7d0c546585959480c6e"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    manifest_sha256 "86c04b25f03dd8807927b51a72e1e2205ade938b56b81ca8e3f3f8febe132c0d"
    sha256 cellar: :any, arm64_golden_gate: "eebf6ac26374c8d65efdada4c332db4bc62280ca3504febbca8f5ab0fe8ab89e"
    sha256 cellar: :any, arm64_tahoe:       "6d6b161bc2ede32fb5404b09d81e1a75c2a0c44520f32368db2cff7da6fa6418"
    sha256 cellar: :any, arm64_sequoia:     "f9f9b9aa18ac9d95aa964d84803d454972df798a2d4da26628ec50c990b873e8"
    sha256 cellar: :any, arm64_linux:       "cfc4d7e4a844799753615b9aad4410389da8721035414c3506363baf2b3a20f9"
    sha256 cellar: :any, x86_64_linux:      "ead1f4ef7ff1c9a2a1560a37cf85cc59fac336ffa7d1b226375aa73a8f82cc2d"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat" => :test
  end

  # https://zlib.net/zlib_how.html
  resource "zpipe.c", :test do
    url "https://raw.githubusercontent.com/trifectatechfoundation/zlib-rs/refs/tags/v0.6.2/libz-rs-sys-cdylib/zpipe.c"
    sha256 "4fd3b0b41fb8da462d28da5b3e214cc6f4609205b38aaee1e20524b57124f338"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "libz-rs-sys-cdylib/Cargo.toml"
  end

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append_to_rustflags "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    testpath.install resource("zpipe.c")
    ENV.append_to_cflags "-I#{formula_opt_include("zlib-ng-compat")}" if OS.linux?
    system ENV.cc, "zpipe.c", *ENV.cflags.to_s.split, "-L#{lib}", "-lz_rs", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end

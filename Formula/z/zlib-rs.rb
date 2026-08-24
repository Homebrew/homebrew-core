class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "a2dac1f1102f01a2da1ec5b708f8f3832cedad138a6732f241204fa0f3617b81"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23045e7acabdf73ca3fca0ea9aa6676dfdfaa1454afeedebf323977348a82da6"
    sha256 cellar: :any, arm64_sequoia: "91fbda2138f199f09f2e0c2a46e44a5f36a627bd5aabda6eba9f30c678499ce7"
    sha256 cellar: :any, arm64_sonoma:  "6fd19133e9c2dbca2edc81ddbf5079eccc807e6d05b86ecc106c7212aaae3e11"
    sha256 cellar: :any, sonoma:        "1712abb67f3c33a8db75982d144cbcb7ded9549e08fafdee2678a6b93fb2d6a7"
    sha256 cellar: :any, arm64_linux:   "0ae5139c20f4017cde276757f6350efd8c7aa439358188f648e250b568b3eb17"
    sha256 cellar: :any, x86_64_linux:  "dc27d1acaf6fa799684d8a98eb8edfbc5854ee22d1b3eeabee0c2090ac3faca2"
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

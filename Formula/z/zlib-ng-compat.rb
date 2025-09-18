class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.5.tar.gz"
  sha256 "5b3b022489f3ced82384f06db1e13ba148cbce38c7941e424d6cb414416acd18"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b32d94fa0ff7dc3280c0241fde0c08f57b07150957df9c835e0d2495b2021284"
    sha256 cellar: :any,                 arm64_sequoia: "d45195acef3111fc30f38266ceb5aab77039826629f4edd15897146ca05b7504"
    sha256 cellar: :any,                 arm64_sonoma:  "e6cb4d804686d11b277d4a2cb11ddd5ab4cce08a49488e35a1c906729e3ba928"
    sha256 cellar: :any,                 arm64_ventura: "5dfd915e6230af6ef5b47d84d47aa8a2637c4cf394b3738c82ad3965b9e922b0"
    sha256 cellar: :any,                 sonoma:        "161a20f0d8ebcc6b35420e4432f76030a3185d59a46c70372ee8774eaddb3d31"
    sha256 cellar: :any,                 ventura:       "e3cf0ba70aa78eb5aab4781eab9dc83d1f42f8a738ff1972ddaa89194aa62cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63f4ad278cdc3ff300a20c6942d02aaaa546e2b5a5dccff15cc4ef399ba1ef50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c3a36039641f76ec48434419c63e422c8a28ee9027492bcd57860e56f2e8c2"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  on_linux do
    keg_only "it conflicts with zlib"
  end

  def install
    ENV.runtime_cpu_detection
    # Disabling new strategies based on Fedora comment on keeping compatibility with zlib
    # Ref: https://src.fedoraproject.org/rpms/zlib-ng/blob/rawhide/f/zlib-ng.spec#_120
    system "./configure", "--prefix=#{prefix}", "--without-new-strategies", "--zlib-compat"
    system "make", "install"
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "homebrew-test_artifact" do
      url "https://zlib.net/zpipe.c"
      version "20051211"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    testpath.install resource("homebrew-test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end

class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.4.tar.gz"
  sha256 "a73343c3093e5cdc50d9377997c3815b878fd110bf6511c2c7759f2afb90f5a3"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2d7639b525b2b29a92177ba00e7f9dd20d7d686cb70bfeb7a4ed188b3c8facd"
    sha256 cellar: :any,                 arm64_sonoma:  "c5349d5f9559feff1607c65e71522907e1ce5f0c7c7409ff6b0ee02142f3de9f"
    sha256 cellar: :any,                 arm64_ventura: "b83317e0a1ca1730f74a02edf766237627d3799fad25e17274b1bd3b944ab7be"
    sha256 cellar: :any,                 sonoma:        "e290f3ee57dfd952c5a901b12a1939d4acf3f49778ab975fbf884390be21ef81"
    sha256 cellar: :any,                 ventura:       "1951f082859a44e33e0ae0d86d60ff9e3800654945e3c75aec0ce67da58277d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f720023d21a91e58098f474093e58aeb81cf8c7c643bd28f2eb2510c3427b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f0416dc6d54348eddc7a621f3ec918069915ff9ec503a8ab88c3b9c677695b"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  on_linux do
    keg_only "it conflicts with zlib"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    ENV.runtime_cpu_detection
    # Disabling new strategies based on Fedora comment on keeping compatibility with zlib
    # Ref: https://src.fedoraproject.org/rpms/zlib-ng/blob/rawhide/f/zlib-ng.spec#_120
    system "./configure", "--prefix=#{prefix}", "--without-new-strategies", "--zlib-compat"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end

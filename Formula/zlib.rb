class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.2.13.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.13/zlib-1.2.13.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.2.13.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.2.13.tar.gz"
  sha256 "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "565286ede6cc691fb781b96a76235d714159bf47c7af2cadbca01bffa92bd785"
    sha256 cellar: :any,                 arm64_monterey: "71825106a1d3cc348f145e58a0f2580f7394c6e747455041551517bb0958b9a6"
    sha256 cellar: :any,                 arm64_big_sur:  "5dfa4fd7fb89f0aff96b98965da0af7e01ef6c3b8f4a90f7b2b135e2f757783f"
    sha256 cellar: :any,                 ventura:        "39899e784ac736887dd6b5a08740c0a625bcb5da06fa473dede99c67b7fcbccc"
    sha256 cellar: :any,                 monterey:       "ceee8b2e24b0c8e7fbb72d63f7844a0cdf4677771e94c46153190ba11be0f48c"
    sha256 cellar: :any,                 big_sur:        "c7e4e0fed83c7515f658f802604e2b6a0be47f1020d4ddfd2025aa748641fe00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087e022c50655b9a7cdfd980bcff0764ce0f53f02724d4a9cbb7ba3b68b863a9"
  end

  keg_only :provided_by_macos

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert_predicate testpath/"foo.txt.z", :exist?
  end
end

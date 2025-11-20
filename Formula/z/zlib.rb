class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.3.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3.1/zlib-1.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.3.1.tar.gz"
  sha256 "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b1f6105bc71a21cad7eb7015d9d363ec1097bf80f91fd3c0d56bc0bece086364"
    sha256 cellar: :any,                 arm64_sequoia:  "a801a93f88dba4df7319e46cd9ea5939351e73f7aa62a5153a2f7a0b0d79404d"
    sha256 cellar: :any,                 arm64_sonoma:   "f867540472a59ab3fb1201625df546593e5fae2e98948c4c16c6154b0468b682"
    sha256 cellar: :any,                 arm64_ventura:  "9033eedbd240076116fea9fa181882e75edee7fe0c5d2e3850258a185c52792f"
    sha256 cellar: :any,                 arm64_monterey: "ebf10e203575beb64d6a8637ec2dc31774fa3141cfccab8ae7039f88b9efa7f6"
    sha256 cellar: :any,                 sonoma:         "217f4245cd1da65a3388f512530089f526cd63a38d49ee5f29a90576dfeb3bb7"
    sha256 cellar: :any,                 ventura:        "6012d7831245716d8507da3d1eb14ad274f8aa0b71b59275fe6bbbd6cebd787f"
    sha256 cellar: :any,                 monterey:       "56bbfa3d7bd6a5ccf17ffa53ab926e67f24e74bd64b4740b56fd96c312e37c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8f5d3038615e17d8de3a4b92895a151388e7adfe608f295f89aa669604541f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f2469db2ce63b70855a98e5ee27b5b5a92874e52542cbdc0b230bba1e7195f"
  end

  keg_only :provided_by_macos

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    mirror "http://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end

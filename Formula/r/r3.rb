class R3 < Formula
  desc "High-performance URL router library"
  homepage "https://github.com/c9s/r3"
  url "https://github.com/c9s/r3/archive/refs/tags/1.3.4.tar.gz"
  sha256 "db1fb91e51646e523e78b458643c0250231a2640488d5781109f95bd77c5eb82"
  license "MIT"
  head "https://github.com/c9s/r3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b6f7a41b6a7f3197243733ce8a7bd9837f0d96b3b1d78046e8ed135db7a7109b"
    sha256 cellar: :any,                 arm64_sequoia:  "0e983875043e6a6111ce6f46615faf14adb57a8fa96c7a1cf5ae10d7d415a879"
    sha256 cellar: :any,                 arm64_sonoma:   "9648d6bd8f125398cc101581e8ee3b8b304fa6e8ab92f018dc538843c04fd920"
    sha256 cellar: :any,                 arm64_ventura:  "fa1e649709ce6c6d16c631a2192d2dd7fea34b7398e55eabe5f7bd51953745ab"
    sha256 cellar: :any,                 arm64_monterey: "2f26748893003e7e0b99a574126c06c451222144979b0230babe37128328214f"
    sha256 cellar: :any,                 arm64_big_sur:  "be0883f3dfc67b2469eef537376a04bbae36ec3aab8ca58ffb66491a81e6db5d"
    sha256 cellar: :any,                 sonoma:         "bdf44bc7e03016c2b5c4b2f414d2c4560d6b6a502023f5225dfb98cbd615d9fb"
    sha256 cellar: :any,                 ventura:        "95f67c8b6bd1c106e6c61623df3ea82a5faf030928bb4a996fb1bea738f27679"
    sha256 cellar: :any,                 monterey:       "a33cc32d0cfb9190bb99931d5dc9dba21899df9103ef7d892b8b083672d78662"
    sha256 cellar: :any,                 big_sur:        "c9fa16048947ebd0c297b700ff7a528c7e45f46bd719cd196d4f7c74de7b491d"
    sha256 cellar: :any,                 catalina:       "96787f402bbc3a37207c3d5c3468d3b98028a12335a66d176d18d268e2406462"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0d5a55e6af91f035641e99ced2f417050df5bb6d782922cb7270866659fe105d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36037bda00ae1253fb158f5cdf2619c2194a33a6ddb6598f9fb7901f37928348"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jemalloc"
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-malloc=jemalloc",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "r3.h"
      int main() {
          node * n = r3_tree_create(1);
          r3_tree_free(n);
          return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-o", "test",
                  "-L#{lib}", "-lr3", "-I#{include}/r3"
    system "./test"
  end
end

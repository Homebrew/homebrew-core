class R3 < Formula
  desc "High-performance URL router library"
  homepage "https://github.com/c9s/r3"
  license "MIT"
  head "https://github.com/c9s/r3.git", branch: "master"

  stable do
    url "https://github.com/c9s/r3/archive/refs/tags/1.3.4.tar.gz"
    sha256 "db1fb91e51646e523e78b458643c0250231a2640488d5781109f95bd77c5eb82"

    # Backport of https://github.com/c9s/r3/commit/c105117b40d1a7b2b9ddf1672cd08b11bd565bd9
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/7ecb03ef6d73f3ed71546fb0c34023f9a23dbd74/Patches/r3/1.3.4.patch"
      sha256 "c00d9af0b30d94d918cf438834f2ca06e1f756ee56ed0205f9f6f82bf909cb0e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ee6d57c13ed2ec24283ad9837f731a7964943070535d903206e8b7481a73dfad"
    sha256 cellar: :any,                 arm64_sequoia: "a6aaba3f459b35b6ef04844f558fc82886c589159e406ad206a0a62e6b15cc1d"
    sha256 cellar: :any,                 arm64_sonoma:  "8a3ba999410ade8c4c63d420e75f480a6c655172f462da5ed1e61ef4614b2861"
    sha256 cellar: :any,                 sonoma:        "6ab1c2ef8e37e2d55981cb55fb8ea9556521f4cd9df65792f909573e72d05bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b947da0474e0674ab147aa19a3e7d6a5adbf6f22eeb99445be3e43e6af89ff58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06edf11bc09dab6f013e3d3ec0c2789572bd64fbdabcb546e6b87600d3c48d4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jemalloc"
  depends_on "pcre2"

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

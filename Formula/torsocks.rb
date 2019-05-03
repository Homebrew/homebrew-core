class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitweb.torproject.org/torsocks.git/"
  url "https://git.torproject.org/torsocks.git",
      :tag      => "v2.3.0",
      :revision => "cec4a733c081e09fb34f0aa4224ffd7b687fb310"
  head "https://git.torproject.org/torsocks.git"

  bottle do
    sha256 "4d16b374c18800543dda79ec5618ba048d1b85d4d75eb229e7c584b69aaab02c" => :mojave
    sha256 "8ab3874d27a0f2e343b2fe19e596ce369d571055b6aae6cbcf5cf33609731262" => :high_sierra
    sha256 "aa753c8002d5dbd78aa75b5bfd284646dd724a65f4896cb3f902b1c7283fd96a" => :sierra
    sha256 "3b978df65102580b8817d6d92e517ecd3a9f7086970c10af279a8d57fea60cae" => :el_capitan
    sha256 "7f1fd0440c3775776bddcb55f153108d0715a3ac9ee8a6a13798d168fbd71e41" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # https://trac.torproject.org/projects/tor/ticket/28538
  patch do
    url "https://trac.torproject.org/projects/tor/raw-attachment/ticket/28538/0001-Fix-macros-for-accept4-2.patch"
    sha256 "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/torsocks", "--help"
  end
end

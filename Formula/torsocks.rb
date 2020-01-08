class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitweb.torproject.org/torsocks.git/"
  url "https://git.torproject.org/torsocks.git",
      :tag      => "v2.3.0",
      :revision => "cec4a733c081e09fb34f0aa4224ffd7b687fb310"
  head "https://git.torproject.org/torsocks.git"

  bottle do
    sha256 "e29d0428907ea2d5aecfbeeb70de35998082a899cc5a86b312c5b264c6ed442c" => :catalina
    sha256 "a69a7a23628c4a79c216b114ccdd0bbd20b76513f5f16eaea2eab8be17473323" => :mojave
    sha256 "14a21746072ddb73f7fc3157dbe41bcce90e0bcb0a3761646faf421294e3ecff" => :high_sierra
    sha256 "c2eb93f0ef7d44ca1c74ccc210d0a2a3fa2a45a7ef46c7ec68f68fb4162e5905" => :sierra
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

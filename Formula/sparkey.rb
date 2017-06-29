class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-0.2.0.tar.gz"
  sha256 "a06caf23c64e7ebae5b8b67272b21ab4c57f21a66d190bfe0a95f5af1dc69154"
  revision 1

  bottle do
    cellar :any
    sha256 "39ca663abe1ce32ff1be2ad2df16d577ecd10227ed572d2cd8dc7b58dc819083" => :sierra
    sha256 "df7252d18e95186e4f698b201d821b08e18aa4aba990607f91dec4dac14471bb" => :el_capitan
    sha256 "271167448d50736d1a2ee012156614cb76950699b0aa243df8656b3c80465109" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sparkey", "createlog", "-c", "snappy", "test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey", "writehash", "test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end

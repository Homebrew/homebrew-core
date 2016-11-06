class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "http://www.impredicative.com/ur/urweb-20161022.tgz"
  sha256 "7a021313b938a033aa13a33d340d3cdf0a867ee1919e9f62b34a38d294400618"

  bottle do
    sha256 "01d9057bc11646f5395d8e821a04f0ab01cea626fb449a2beabf692c7acb419a" => :sierra
    sha256 "53c8b4cb36927ed7cbaac13510a1d2c466ec8d81256d166a8c04a61d1ae6c7f0" => :el_capitan
    sha256 "3621c22bdf581c6c1bc6d89d7b85ac11917f9b8106a0c1874cc1c19519c8f930" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "openssl"
  depends_on "gmp"
  depends_on :postgresql => :optional
  depends_on :mysql => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --prefix=#{prefix}
      SITELISP=$prefix/share/emacs/site-lisp/urweb
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/urweb"
  end
end

class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "http://www.impredicative.com/ur/urweb-20170105.tgz"
  sha256 "2ad3aea2c4851c9b18f752d38c7127af8293fbbbbdb3dd06b73a4603fe399b67"

  bottle do
    sha256 "5f406928ad3e00bc835b7b04e29a9a3edad0e727ebc5e16c650a72bed19d8766" => :sierra
    sha256 "f98d2b47c5736ef2a2e014933e16d09f9a9a32d4668fd5f022032510df6494e3" => :el_capitan
    sha256 "116d3adc41454c84331d646094bc73857f9ba8020cce7891b67d5d03d458da7d" => :yosemite
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

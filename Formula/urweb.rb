class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "http://www.impredicative.com/ur/urweb-20160805.tgz"
  sha256 "e946f37bf390156e526d5e2198ad5c3497c6e52eb814f76ddd580d6315e25ca3"

  bottle do
    sha256 "de2f38ae993329e757a3a595d4af95e13bea9c3502ebb25fb613df006dfa6a69" => :el_capitan
    sha256 "f76d92fbe09cd5fefc6ebc2cdbe97b431c26d21a5a2eee331f0eea5cac283c81" => :yosemite
    sha256 "71014e3a1755d68557ba8dfc2b7228dde65b00b40d505f24c000a61118f8991f" => :mavericks
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

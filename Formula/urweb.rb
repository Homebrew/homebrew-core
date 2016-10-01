class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "http://www.impredicative.com/ur/urweb-20160805.tgz"
  sha256 "e946f37bf390156e526d5e2198ad5c3497c6e52eb814f76ddd580d6315e25ca3"

  bottle do
    sha256 "b42520aa61122526fef9ba7bd8de9710a74b18a784384eb86dac3d33376d4545" => :sierra
    sha256 "0bd4ed70d7d4c5ba6bf1e52a0ad15368cfb8f54a94ba886c6b9f87c3c5a238a9" => :el_capitan
    sha256 "a5ec0848da0171407e7979eed6f7213b8f9e492ca215b595b59540bd2866a13a" => :yosemite
    sha256 "7c53d5d03f727ea1a8cd9db4de7763f15f3efd0fc4f26ef493cca399516f64f9" => :mavericks
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

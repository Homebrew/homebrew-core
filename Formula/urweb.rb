class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "http://www.impredicative.com/ur/urweb-20160515.tgz"
  sha256 "58c5cc0e96f0c311de468b4475e4bf595e6de5c04095136eed4148545e70442f"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "mlton" => :build
  depends_on :postgresql => :optional
  depends_on :mysql => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-openssl=/usr/local/opt/openssl",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/urweb"
  end
end

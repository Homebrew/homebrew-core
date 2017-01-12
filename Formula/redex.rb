class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "http://fbredex.com"
  url "https://github.com/facebook/redex/archive/v1.1.0.tar.gz"
  sha256 "af2c81db4e0346e1aeef570e105c60ebfea730d62fd928d996f884abda955990"

  head "https://github.com/facebook/redex.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "python3"
  depends_on "jsoncpp"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/redex", "-h"
  end
end

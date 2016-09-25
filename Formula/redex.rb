class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "http://fbredex.com"
  head "https://github.com/facebook/redex.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python3" => :build
  depends_on "boost" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "libevent" => :build
  depends_on "openssl" => :build
  depends_on "jsoncpp" => :build
  depends_on "openssl"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end

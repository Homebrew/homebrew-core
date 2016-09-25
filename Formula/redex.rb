class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "http://fbredex.com"
  url "https://github.com/facebook/redex/archive/v1.0.0.tar.gz"
  sha256 "58a41e7fb224c74438431d579f3ffa0ea7758d07730361d8a06d2c9e75d803a2"

  head "https://github.com/facebook/redex.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python3" => :build
  depends_on "boost" => :build
  depends_on "double-conversion" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "libevent" => :build
  depends_on "jsoncpp" => :build

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

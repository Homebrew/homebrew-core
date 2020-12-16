class Redsocks < Formula
  desc "Transparent socks redirector"
  homepage "https://darkk.net.ru/redsocks/"
  url "https://github.com/darkk/redsocks/archive/release-0.4.tar.gz"
  sha256 "618cf9e8cd98082db31f4fde6450eace656fba8cd6b87aa4565512640d341045"
  license "Apache-2.0"
  revision 2

  bottle do
    cellar :any
    sha256 "56c01e00be78f835dbf5201d2f90fdee9670e3faa4781a2b3c55702b67a47b28" => :big_sur
    sha256 "8e16eb3b2db86a06e6d6eae77a7f2fa20f59f7536ccbd0b9ad15778dfdf31212" => :catalina
    sha256 "0da35f33e9faaf37c59043a5f20d1e4a89f5b543644332b856a525183f31fe96" => :mojave
    sha256 "4f8630032cb62bc1cc9f318a837ea0f42964704e2310115696766c8a51f8b5f2" => :high_sierra
    sha256 "9b528c2ce745b2402d15073e7da4fb62789789caa70e5373946ae1699f663b8b" => :sierra
  end

  # 0.5 build did not get addressed and no release since 2016-12-27
  # https://github.com/darkk/redsocks/issues/96
  disable! date: "2020-12-13", because: :unmaintained

  depends_on "libevent"

  def install
    system "make"
    bin.install "redsocks"
  end

  test do
    system "#{bin}/redsocks", "--version"
  end
end

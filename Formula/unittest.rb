class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "https://unittest.red-bean.com/"
  url "https://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha256 "9586ef0149b6376da9b5f95a992c7ad1546254381808cddad1f03768974b165f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f449bf2ba73aaf03dd8316d6057639bd2c3a38ef347157f3721cbabfb60212f" => :big_sur
    sha256 "2da59f3f0206902816c2dac6c273768858f092eb917b696b0a8b04096ea97007" => :arm64_big_sur
    sha256 "ef8f5c6e18c32b813cb825ce467a6997592dca4762833f8e03f156629ffa74f9" => :catalina
    sha256 "a1ab22f2b4904a5c03ea8642fa096166b9fcc131e535a1d15e07772e1fbcea8d" => :mojave
    sha256 "b34ab2aa983e33bf86eda07a58af410a769da7e969620e479c6f7e965de2c397" => :high_sierra
    sha256 "c997c9ce2d6984607af24a6dc7dc21ddefc0570a15d2fb61192b3a361120a83d" => :sierra
    sha256 "501b61d05de70cfb53116c66daf380cb35a1665eeecf34dfc6b27ab945458f43" => :el_capitan
    sha256 "8e26d281818bdf26ae2876004f5388fee9bd954589f57a6a25c979949e5f5bf1" => :yosemite
    sha256 "2acbb80540c9ff3c17cf4ab95db16657947761813915a94fa4afc0204e4b09b3" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "test/unittesttest"
  end

  test do
    system "#{pkgshare}/unittesttest"
  end
end

class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "http://fbredex.com"
  url "https://github.com/facebook/redex/archive/v1.1.0.tar.gz"
  sha256 "31c41ec774577875782ac83bfd9a03520c7bfcb1a04026fb35417803a319d749"
  revision 1
  head "https://github.com/facebook/redex.git"

  bottle do
    cellar :any
    sha256 "c66e4160ebdcad99f1854a99fa6fefc8a8da2f1bc62d808cc1aa79cd9e2c2bed" => :high_sierra
    sha256 "0486e6105e25f310e802b4adc0f6e50ad2fcb02c4b1d4edc1f85d16963892b86" => :sierra
    sha256 "af389493d114dac27c04ec780d16c4865591c1fa5e611e9b84f94f0562b22078" => :el_capitan
    sha256 "3c8b98773de86c4025b3f2be18a3666987b5e06b958f1bf03c64ab2e3193c8e7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "python3"
  depends_on "jsoncpp"

  resource "test_apk" do
    url "https://raw.githubusercontent.com/facebook/redex/master/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("test_apk").stage do
      system "#{bin}/redex", "redex-test.apk", "-o", "redex-test-out.apk"
    end
  end
end

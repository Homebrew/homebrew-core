class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com"
  url "https://github.com/facebook/redex/archive/v2017.10.31.tar.gz"
  sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"
  head "https://github.com/facebook/redex.git"

  bottle do
    cellar :any
    sha256 "d8772db5f39270a047241f27c7f2aa2d9b7ba6313213e372728640448454ace0" => :high_sierra
    sha256 "0dac7538726f7fba1cfc702c4b3cbe844f71fd246a97bee629ca298073720ccd" => :sierra
    sha256 "05fb9c8ff8a2b3b516fd80e326ebc8ba174eae3305e69ffc057b43d874e4983d" => :el_capitan
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

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

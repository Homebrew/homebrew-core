class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com"
  url "https://github.com/facebook/redex/archive/v2017.10.31.tar.gz"
  sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"
  revision 2
  head "https://github.com/facebook/redex.git"

  bottle do
    cellar :any
    sha256 "1238aba94a455c15ab04cbe425c6b42afb8b0c31e117d9146686a1986386c6e4" => :mojave
    sha256 "3af2c80e3680ee759285ebb1939530b8f5e15315c6a98d64e2334ac6f1abb907" => :high_sierra
    sha256 "eeca9a5992edfc721cf08ea9c86d59c4110998af603e447213da01cc84d6216c" => :sierra
    sha256 "6bf545087ea1d01922b9cc5a157b941785b3e1abe339d45a50745ddfdf21d8fd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python"

  resource "test_apk" do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
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

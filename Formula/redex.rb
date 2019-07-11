class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com"
  url "https://github.com/facebook/redex/archive/v2017.10.31.tar.gz"
  sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"
  revision 3
  head "https://github.com/facebook/redex.git"

  bottle do
    cellar :any
    sha256 "3fdb0934bc6c433012cd90838cd5bf5596631c88b0f6442d4ef7e862300ca933" => :mojave
    sha256 "9b7043294449d585d6a9437997ecd6d0e5d04fda4d6e3b84ed117fa3489a292f" => :high_sierra
    sha256 "5b50d1e1bdd836835043055e3ca1bb380aab6c896512096a6424110a9ad3de14" => :sierra
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

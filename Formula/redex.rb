class Redex < Formula
  desc "Bytecode optimizer for Android apps"
  homepage "http://fbredex.com"
  url "https://github.com/facebook/redex/archive/v1.1.0.tar.gz"
  sha256 "af2c81db4e0346e1aeef570e105c60ebfea730d62fd928d996f884abda955990"

  head "https://github.com/facebook/redex.git"

  bottle do
    cellar :any
    sha256 "11f80b6cc9ea4967d23972c66bc115a11b9fae6e0420f78c8744215979efc7cb" => :sierra
    sha256 "c069b63acba15031c739a73a62637dd7ee7a56d341d6b46de06e35dd9971ba36" => :el_capitan
    sha256 "fac8aa70fd659224fa932d2b469596b68351623333f70704c4d3e9f1b7dcf2df" => :yosemite
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

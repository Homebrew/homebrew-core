class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "a27e8160aca5d3aa5a6525b930da7edde44f8824dd4fba39aaef3b9af2717b74"

  bottle do
    revision 1
    sha256 "58b70f797b4d0066d596a4171abd47e2271a99a7b286ac20e75de1db1dc1a6b5" => :el_capitan
    sha256 "8ff93afa65476997671b4dc8668adda260fd3a1c592d98257fe0629fc814c42c" => :yosemite
    sha256 "80479a279dcc7297990317a2a4af0a56e82a7bb3936081571cf486005a743a63" => :mavericks
  end

  option "with-big-integer", "Use 64 bit precision instead of arbitrary precision for performance"
  option "with-ssl-verification", "Enable SSL peer certificate verification"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DZORBA_VERIFY_PEER_SSL_CERTIFICATE=ON" if build.with? "ssl-verification"
    args << "-DZORBA_WITH_BIG_INTEGER=ON" if build.with? "big-integer"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end

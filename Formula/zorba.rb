class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "a27e8160aca5d3aa5a6525b930da7edde44f8824dd4fba39aaef3b9af2717b74"
  revision 3

  bottle do
    sha256 "557048a6f8d3d3b4388fdcae8b4098e0a3d9c03283a5e4ff990a93b1c901db97" => :sierra
    sha256 "cccd89e2658fba63c13721285b3d4b95ac898dd5679d5dde6232d9af26631e83" => :el_capitan
    sha256 "4f98c3c2539cabb1a9334502be226b538328d888f0983fc998f8b40ec4e57aef" => :yosemite
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

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DZORBA_HAVE_CLOCKGETTIME=OFF"
    end

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

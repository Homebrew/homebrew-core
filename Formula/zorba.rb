class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 4

  bottle do
    sha256 "09f9a818113700df3f5b2721ae73266888fc7fb1c4d15ce5c7644d9851bb11a6" => :high_sierra
    sha256 "fd1079300b056e1babd7820ede1bb59ebf51e6feaefcff1df52d906269ca0236" => :sierra
    sha256 "5db8c34b82c98308f3404858e960cb5ce70234a3a4e94136284de2fb919c4bc2" => :el_capitan
    sha256 "3fa016f851209471fdcbf5dab38da3260238d5f8c2f6057d02ae415ea7c85c8c" => :yosemite
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

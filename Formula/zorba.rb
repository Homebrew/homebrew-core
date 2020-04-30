class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 12

  bottle do
    sha256 "e8e7fa7fae4556a6af019a1c61e22e15be074ea30b61f3d22a87af86f0548c21" => :catalina
    sha256 "d3e67cd2b3cb7c284f3f153698069074eaffe13889131d704b87e25b09ac8416" => :mojave
    sha256 "923126ec43c7fbb8c00d0e4e42f47eafc0731e07abc5bc8d02133f4eab90aa96" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  uses_from_macos "libxml2"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  def install
    # icu4c 61.1 compatability
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11

    args = std_cmake_args

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    args << "-DZORBA_HAVE_CLOCKGETTIME=OFF" if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

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

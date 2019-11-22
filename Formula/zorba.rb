class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 10

  bottle do
    sha256 "3678cc7bc0c3e8cfc5214fbd8ea86e6491205bd1b83a92e95611acd3173332b1" => :catalina
    sha256 "55376a15e18dff204a8c5699749249d880e18823f9c6bc33c1331eb83e13ba3f" => :mojave
    sha256 "4fed67773a58207a2ead212f4250ea74febf4bd4ba114f9f5092a7cc5face43b" => :high_sierra
    sha256 "d2bbe83eaf99a61e496b6fd923c4ae0ff809af4fc2557170d84293a3607db46f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  def install
    # icu4c 61.1 compatability
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11

    args = std_cmake_args

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
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

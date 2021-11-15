class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 14

  bottle do
    sha256 arm64_monterey: "c49d833711490a7297a1f175a80ca3e2ef0c6bbdd35ba444cdd665d824a95d90"
    sha256 arm64_big_sur:  "aa4cae0f56ef1d035d5ac36ac60b1dc6e4c0a794e97eb8aed539c5fb5f14a215"
    sha256 monterey:       "ab8e4a76a55d1882c9597262d8dfa988a404198ebc3f6f56001da5ebb19fb014"
    sha256 big_sur:        "dadda2e73de44c8994fa09671bda4781ce88bd5a3836c335ecdcfbd9c20f1dfc"
    sha256 catalina:       "8c0de8c4961888f97768b0f1a9d5ce2af9fdebd7cce2626b4a0c4f9bb7508c3d"
    sha256 mojave:         "511bab00060dd21851440ad2cc0f64e9edec6b1beef2675505baaa6745154670"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  uses_from_macos "libxml2"

  conflicts_with "xqilla", because: "both supply `xqc.h`"

  def install
    # icu4c 61.1 compatibility
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    # Workaround for error: use of undeclared identifier 'TRUE'
    ENV.append "CFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"
    ENV.append "CXXFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"

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

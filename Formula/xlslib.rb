class Xlslib < Formula
  desc "C++/C library to construct Excel .xls files in code"
  homepage "https://sourceforge.net/projects/xlslib"
  url "https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.5.0.zip"
  sha256 "05a5d052ffdd6590755949d80d16a56285561557bc9a5e887e3b8b3fef92a3f3"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a846a14e97ca4104d9d56be6ba54c6159a798b334b8172d1c941848bb3581aa"
    sha256 cellar: :any,                 arm64_monterey: "6aa0abeea10e22729ad231d42c44b194eff33d203c786f05fdbc72e6a62a590d"
    sha256 cellar: :any,                 arm64_big_sur:  "7e4fb2b977db04da50bae5952609b346fb2fd3b2687f2226747c1ff3401f9450"
    sha256 cellar: :any,                 ventura:        "cf8a30118932104eb0e9a53bf3ca590356a6c4a8ab9b87229b9b3fc58df860ec"
    sha256 cellar: :any,                 monterey:       "f40738098dfd10961f28deb59266aa468165ca9011658852a3d8a97f51742175"
    sha256 cellar: :any,                 big_sur:        "a4b1d70f77f5cab84266761845d3910821315696114c3c19250660d4a9bd18a0"
    sha256 cellar: :any,                 catalina:       "9db0f101930faf04be3a8c7cccfafefeb82efc3009e88ab7494296b371631bc3"
    sha256 cellar: :any,                 mojave:         "4cb1f1572aabd2918427724158ef6361390ee0f5268a3c14cb8ecf09a9f7c00d"
    sha256 cellar: :any,                 high_sierra:    "bb4b5aa643155d211af17a47b5337d65431b1ade0e233af9770d62dbb7ab1448"
    sha256 cellar: :any,                 sierra:         "bcdef576e03aa1cad74d341f6fcc72a1e7944a54542941f96cb8ef8063c2190e"
    sha256 cellar: :any,                 el_capitan:     "a4d5714e19c1d4e44d67bbe9cda064120dc01e9cf207771ae5ef208e76ed2cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be639eb5da6af885ea1d8c549b8cf4a40aba417b550ea64b29caf6f9600bc4a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    ENV.append "LIBS", "-lstdc++" if OS.linux?

    cd "xlslib"
    system "autoreconf", "-i" # shipped configure hardcodes automake-1.13
    system "./configure", *std_configure_args
    system "make", "install"

    (pkgshare/"test").install Dir["targets/test/*.{cpp,c,h,md5}"]
  end

  test do
    cp_r (pkgshare/"test").children, testpath
    system ENV.cxx, "mainCPP.cpp", "md5cpp.cpp", "-o", "test", "-I#{include}/xlslib", "-L#{lib}", "-lxls"
    assert_match "# Test finished", shell_output("./test 2>&1")
  end
end

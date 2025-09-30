class Xlslib < Formula
  desc "C++/C library to construct Excel .xls files in code"
  homepage "https://sourceforge.net/projects/xlslib/"
  url "https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.5.0.zip"
  sha256 "05a5d052ffdd6590755949d80d16a56285561557bc9a5e887e3b8b3fef92a3f3"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0aceee9730d6524acd094d61efcf3b89387d79c7e10dc3bbbac4cf52ccb133ac"
    sha256 cellar: :any,                 arm64_sequoia:  "67eee141556944e992f338143289b2021e22023d5f205f571e56bca3a8c2b1f3"
    sha256 cellar: :any,                 arm64_sonoma:   "f3ac523156480b0b00cf8ef98e2687e7ca0ac2b6107186f14349a0566c57de76"
    sha256 cellar: :any,                 arm64_ventura:  "8a846a14e97ca4104d9d56be6ba54c6159a798b334b8172d1c941848bb3581aa"
    sha256 cellar: :any,                 arm64_monterey: "6aa0abeea10e22729ad231d42c44b194eff33d203c786f05fdbc72e6a62a590d"
    sha256 cellar: :any,                 arm64_big_sur:  "7e4fb2b977db04da50bae5952609b346fb2fd3b2687f2226747c1ff3401f9450"
    sha256 cellar: :any,                 sonoma:         "86148ddd46d4a6c9a4170b0d97c7abb6726e5210ccead20325350c434f3a4d4c"
    sha256 cellar: :any,                 ventura:        "cf8a30118932104eb0e9a53bf3ca590356a6c4a8ab9b87229b9b3fc58df860ec"
    sha256 cellar: :any,                 monterey:       "f40738098dfd10961f28deb59266aa468165ca9011658852a3d8a97f51742175"
    sha256 cellar: :any,                 big_sur:        "a4b1d70f77f5cab84266761845d3910821315696114c3c19250660d4a9bd18a0"
    sha256 cellar: :any,                 catalina:       "9db0f101930faf04be3a8c7cccfafefeb82efc3009e88ab7494296b371631bc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "40d32ca11dd587663402feb5883cddb2db289ec21b807ed6d462658fe1650cf7"
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
    system "autoreconf", "--force", "--install", "--verbose" # shipped configure hardcodes automake-1.13
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

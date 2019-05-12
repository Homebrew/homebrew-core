class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-8.0.2.tar.gz"
  sha256 "abb81b55ac5f2c90997c0005b1f15b74ed046638b64e784840a139fe21d0a735"
  revision 1
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "3c2f9fd145c39173b04d1b90679079831e6d372e0c6e54d891f96b99dc2a4bf9" => :mojave
    sha256 "cdf03ec44361238c35cd12d71f409cd1b15dbe63ee53a66bd3e8049eee5dbb91" => :high_sierra
    sha256 "40c07a6edfc19c6180c5ea74424932c6845405199382e8fffedfeb300f493d10" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DSWIPL_PACKAGES_JAVA=OFF",
                      "-DSWIPL_PACKAGES_X=OFF",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}"
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end

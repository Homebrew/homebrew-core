class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.2.3.tar.gz"
  sha256 "9403972f9d87f1f4971fbd4a5644b4976b1b18fc174be84506c6b713bd1f9c93"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src"
    regex(/href=.*?swipl[._-]v?(\d+\.\d+\.\d+)\.t/i)
  end

  bottle do
    sha256 "90b6af595ad9b78a386af8d76977d5bcb9611bbba343655bad013dfdfc24c612" => :big_sur
    sha256 "d46306be59beb87062c033be2575b833d1d0cefe87ef1dbe4019fba2e4ea7b4c" => :catalina
    sha256 "ecad13f16b9db9eb64be41741d4a905b3efc9069f6edfb455b48ca0dd2609504" => :mojave
    sha256 "00af33c50aed56b7c8451cfd9e1e25633ba05c14e34d95dffe5d8aa759d606c7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DSWIPL_PACKAGES_JAVA=OFF",
                      "-DSWIPL_PACKAGES_X=OFF",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      "-DCMAKE_C_COMPILER=/usr/bin/clang",
                      "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
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

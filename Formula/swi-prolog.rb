class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.2.4.tar.gz"
  sha256 "f4bcc78437f9080ab089762e9e6afa7071df7f584c14999b92b9a90a4efbd7d8"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "3a899873b22a6e4e380498ec855d2c0c7919c848872087da676d385745e39179"
    sha256 big_sur:       "1a5384ec31ca1088eff1e16d1977a4120f12e8c15e3703ef3c80c564848e2e5c"
    sha256 catalina:      "06c31b007436027785e73cdbf16d82dd6356766b821580a4fceda8db5eb4c86c"
    sha256 mojave:        "1deeaab4064bf3da632a28e539f46790252cfec839ae932bc729ecc239e347c3"
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
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}"
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]

    on_linux do
      inreplace "libexec/lib/swipl/bin/x86_64-linux/swipl-ld",
        HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
      inreplace "libexec/lib/swipl/lib/x86_64-linux/libswipl.so.#{version}",
        HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
    end
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end

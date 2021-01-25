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
    sha256 "ebabde9df23a007923f7abb0c918fbc84f90bc92a170f101296befeb6efbf078" => :big_sur
    sha256 "813121cc7c09abc0496773fd4b94c398761d492365bb255eabf92475bcac205a" => :arm64_big_sur
    sha256 "4b34d51f13525d4ab94959b1734575819e451599f18978ebd7609aa515d092ca" => :catalina
    sha256 "bb9d8579ddf8daaa068f40fc3084c23b204d6110789e08ebbb189196b6fe20e7" => :mojave
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

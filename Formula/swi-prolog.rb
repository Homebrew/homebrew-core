class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.2.1.tar.gz"
  sha256 "331bc5093d72af0c9f18fc9ed83b88ef9ddec0c8d379e6c49fa43739c8bda2fb"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "ff0b739f559d250bd0452f5567fa4484f8152145de2fc6d4854f74851bbbcd40" => :catalina
    sha256 "2f6c8c976324d9afea6fcf4683ed4a953eb4fb14b168de03c7f00399db9707d0" => :mojave
    sha256 "cbe5f89a9a2a0c6802dd731498e6bac1b44277123aa2b326193552d6b6e25165" => :high_sierra
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

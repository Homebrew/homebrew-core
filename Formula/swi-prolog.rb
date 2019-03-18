class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-8.0.2.tar.gz"
  sha256 "abb81b55ac5f2c90997c0005b1f15b74ed046638b64e784840a139fe21d0a735"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "4ce8634e10c98507c9a56d69a3793194f1997918643e4d2c0b1a76c62a238e3d" => :mojave
    sha256 "6e1bbd48b46ecedbeddff4b6a23138fe5b1784c8f8152772fbe945bfb27425f2" => :high_sierra
    sha256 "503b3bf2fb95bd8914617732ac23970789b471e44211c240bab6a63d5a210513" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "ossp-uuid"
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

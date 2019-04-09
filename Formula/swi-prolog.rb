class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-8.0.2.tar.gz"
  sha256 "abb81b55ac5f2c90997c0005b1f15b74ed046638b64e784840a139fe21d0a735"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "1cec5efa06e469a67a7701fa8bc08f320f95ec766f494c305453301a5f8335e6" => :mojave
    sha256 "824e9a80488a9f91f2bab57653baa6794be59c049bdbab464bd8d00510b1147f" => :high_sierra
    sha256 "29f73701075df1cd1bedd01b13fe085d23c74c87285ab12116e1f68554bcfe1b" => :sierra
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

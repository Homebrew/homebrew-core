class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.0.3.tar.gz"
  sha256 "cee59c0a477c8166d722703f6e52f962028f3ac43a5f41240ecb45dbdbe2d6ae"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "0ba7bf8a54b8cfd8a66234642bcec716d9af409b75915918a200e24e952e1597" => :mojave
    sha256 "376b7a441936320d4aed815f7e9cfee176ad805ad29e2b9ba9448bb63455ccfa" => :high_sierra
    sha256 "ae76f9f5b9e9d2267ccf4fd6a5ed117bd4074be12be8cf9e1d53c2ee5add9cd4" => :sierra
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

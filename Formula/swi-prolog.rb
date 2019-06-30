class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.0.3.tar.gz"
  sha256 "cee59c0a477c8166d722703f6e52f962028f3ac43a5f41240ecb45dbdbe2d6ae"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "1f939859822bad18d36ab1a65bb51fa9eafad219cb5f3602ff3f5da5fdc57342" => :mojave
    sha256 "648648853bafd06553bdaf3e508f4eac9364ed317f305268eae70b133eb39a98" => :high_sierra
    sha256 "05a806650cd1a311eda4ab03e5ac941da4cf6e090a8e98be3f13ee5fa61c9441" => :sierra
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

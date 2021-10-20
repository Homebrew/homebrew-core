class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.4.0.tar.gz"
  sha256 "bff0396f827af3d3351eed0582a99cbcd0a66d14a2f5bbf4aeef22332714709f"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d35919949017430b1b51f033d6b6b6efa4de0a3d76298164035f1bbf01e92a25"
    sha256 big_sur:       "10378107cdbaa40a8399e83a1fd25148933fa828bec0f9bb2f50be3043a32e65"
    sha256 catalina:      "3b4865a06b754a7dd03c23c49e83f041ca90ed8f6088dae80b96e6094227f174"
    sha256 mojave:        "2cbb92cb131eaff5a4f3332c2dbdd2082f32c411cf28e83cc1bfab7e7ce08f70"
    sha256 x86_64_linux:  "52d2c9c2d0e22fa0610261b9c64be8cde54352a293cb40aa3b4621195f9cc9c9"
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
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmake/Params.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

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

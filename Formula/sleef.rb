class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  stable do
    url "https://github.com/shibatch/sleef/archive/3.5.1.tar.gz"
    sha256 "415ee9b1bcc5816989d3d4d92afd0cd3f9ee89cbd5a33eb008e69751e40438ab"

    # Fix CMake detection of Apple Silicon (arm64).
    # Remove in the next release.
    patch do
      url "https://github.com/shibatch/sleef/commit/7ce51c447a88e35ad0440a906659920b577984c0.patch?full_index=1"
      sha256 "0056eda409a757602db714bcf9273d525d2421d423f096b0042c85f782ee8af9"
    end

    # Fix build/include/sleef.h:6:2: error: unterminated conditional directive.
    # Remove in the next release.
    patch do
      url "https://github.com/shibatch/sleef/commit/d7f7e84a58243c7ccbbd57d91e282725d302091d.patch?full_index=1"
      sha256 "cf61c4440be028aee934578f7ccf98930bfbec892a7ead1c62dd287dbd658a3c"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "29d31e2b6f752ac2b2224ea8334746484f08caac8b5e007a3ae0c7bfb78938dd"
    sha256 cellar: :any,                 arm64_monterey: "e24cd50466a172fe2fe1fd38145d6380798b3a4358b2618ebcf5d75b53824761"
    sha256 cellar: :any,                 arm64_big_sur:  "72c41de0c2f48173012a81362bd53cc3339de27f716baa7ea5d4b17604cd4a67"
    sha256 cellar: :any,                 ventura:        "a4785640f8657134c06a22f2f427d8a6ace04e6fa8fdd55f1b4261c77625457a"
    sha256 cellar: :any,                 monterey:       "b5b0877f9aec2c35b1c42a06b0a86dbf9cb53c98a11f3399d0cac79a57d7676e"
    sha256 cellar: :any,                 big_sur:        "483dc0549bf982bdcb71e8e3e07be8042d17b52484ddca20425feb820c1fb0fb"
    sha256 cellar: :any,                 catalina:       "0e2a1b3e27c3c886864c498a597f1a9e0c5faae346d4b3a7eceb7ef44f763e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ab3809f9503bbc49c03b1b26b39ffde4ebdf4f5148a375d267ff3cc816ebd6"
  end

  depends_on "cmake" => :build

  def install
    # File rename patch doesn't apply on macOS so manually modify.
    # Remove in the next release.
    mv "src/libm/sleeflibm_header.h.org", "src/libm/sleeflibm_header.h.org.in" if OS.mac?

    # Parallel build is only supported with Ninja, but Ninja causes Apple clang crash
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_INLINE_HEADERS=TRUE",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI / 6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output("./test")
  end
end

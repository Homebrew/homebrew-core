class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.24.1/qbs-src-1.24.1.tar.gz"
  sha256 "1f1a92c840e708bbbc30705e3b0bb1d0cd47ffcf679d566dd071a1768ee65992"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04c2e75a135fc98f9880d37ad19a02d28ba1f0c038b79d441fd935d3a2510bf2"
    sha256 cellar: :any,                 arm64_monterey: "f01f4fbe4a9a2a507be3883913c72d17a0f0b243a13b9efa7f9c3ba2bcde0d95"
    sha256 cellar: :any,                 arm64_big_sur:  "328eae689524bcfdf3fba2954c7125fb6d03cac6b9c683a0405426cbd47091e3"
    sha256 cellar: :any,                 ventura:        "4a407b17d052e9f6d755d7b047ff109247f107a06cf0227e183210aeee498dff"
    sha256 cellar: :any,                 monterey:       "43aba951297187a5e2fbedee085b64a0997a3e1ac1cf2029d8e1b83936a2b043"
    sha256 cellar: :any,                 big_sur:        "ca9a8dba616fbfab1c702e36c63195ab2d85bd0804d81fc6c066d5a95eced857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a73a47a8ab85d9fc02df51215dfb9536e7c428e0b1ac2cff43b9ab1f3716644"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "cmake", ".", "-DQt5_DIR=#{qt5}/lib/cmake/Qt5", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end

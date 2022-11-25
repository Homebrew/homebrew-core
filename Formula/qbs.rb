class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.24.0/qbs-src-1.24.0.tar.gz"
  sha256 "73c9ecb9de766ecbe245a7aac683bd7809f8a5e33a922686b9475fe8f45e467c"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "7910e22de1d208e3cf794549c57cdc78d6c651463c1aeae4d8a5d72454cb590e"
    sha256 cellar: :any,                 arm64_big_sur:  "15cb2014c7faafa70a7f64654940dfef908df0e4f657da120ecc6f2b88ce3e67"
    sha256 cellar: :any,                 monterey:       "ec7c1ef1ad9814ba5e0bb2c9619cdbd67e7e52d38208cebd0bea3b7261bd3d64"
    sha256 cellar: :any,                 big_sur:        "aec65e729c112f4d04d014a62a859d3d1396919040f3c1792a09d710083d98c8"
    sha256 cellar: :any,                 catalina:       "a3bec37e6e7c7a1d4250c0f63a2a3c4bd59956f9a22e4a3e90bbf748af6743a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da623ca66d640bab7fa20b000faf0fef7742dbbb40a9a15465900c9d4682bea"
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

class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.23.1/qbs-src-1.23.1.tar.gz"
  sha256 "8667bb6b91eeabbc29c4111bdb6d3cd54137092b8e574a47171169d3e17d4bef"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "012a61110f01a833ebf58d0c340746a2e26025e8aec85291bd4e6a7ff61a4aeb"
    sha256 cellar: :any,                 arm64_big_sur:  "ec0a73b355d8412a3270a48f9e94c4915d9a2f85fc71fe1650fc94e4018bd71f"
    sha256 cellar: :any,                 monterey:       "9b0a90d79cffd64656bf25044d5bb2d2a487810122ea20c4186fa26a49ffe0a8"
    sha256 cellar: :any,                 big_sur:        "9be3e9403f505135b5f8fcc0d40fbf06bec24239c320096679a723c6ca2d91c7"
    sha256 cellar: :any,                 catalina:       "3243117bf46e7dae7855c8c407d62328f1a75b7bad5f1cb0f9a999d30abdce80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8712e15d31e4376d50662e954a5ef07cb016f0828320c87450b3c085b52b94ab"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

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

class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.20.0/qbs-src-1.20.0.tar.gz"
  sha256 "44961a4bb61580ae821aaf25ebb5a5737bd8fb79ec0474aa2592cdd45cc5171f"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "790518277b00ff84cfd20b7620bd73dae5af73802cf52f44a140cf9d5e2a7c24"
    sha256 cellar: :any, big_sur:       "2607c6c53438d92ce579d76fcfe8b47160af3701c818b3f8ef450d10f3aee9ea"
    sha256 cellar: :any, catalina:      "11331894941bd1154ff295e92b5eabfaa43a7f7646c5e290f2d7f108f6d41ae8"
    sha256 cellar: :any, mojave:        "050718655f3d847ec157bd660b340a4b4fc08d3fbda0c32bb32951e4c37ac484"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

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

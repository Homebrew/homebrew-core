class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.20.1/qbs-src-1.20.1.tar.gz"
  sha256 "3a3b486a68bc00a670101733cdcdce647cfdc36588366d8347bc28fd11cc6a0b"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "67dfbdb18377e3bba450d7e607a4a226ee0ddb813f1bf708508892f8d8468a59"
    sha256 cellar: :any, arm64_big_sur:  "92aac9bdcf321990f97af795af823b02b0f3e747e32b96e2f55f2be34ba5e31f"
    sha256 cellar: :any, big_sur:        "c3d85f2b1e1f08d4f1eafa5635f892d2fd30929b61b78a350904f2e94eb5ccb4"
    sha256 cellar: :any, catalina:       "13e3ffaf58f1778c57fd83eb8da7949dfadd639a25ca259fab7197411cf16cdb"
    sha256 cellar: :any, mojave:         "7e224f3dc560b76aef993ed1b72c8dd51a839928fa3351e77cec37b333b3d534"
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

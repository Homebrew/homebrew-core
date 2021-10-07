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
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "eba2d73bbeacdcbdb1d72e65c8d2ad3bb6cc56a0d290302f2c89a48005b92110"
    sha256 cellar: :any, big_sur:       "b7e70c92ecc0305612035b67584d6836f814fbb3fd028a47475756c85fb00ef9"
    sha256 cellar: :any, catalina:      "9dde21524eb15ac27bb39215309fcee93c647685aaf86d8e2f070008f0de3748"
    sha256 cellar: :any, mojave:        "3ae560f2c8ea18e8ba509b4ae03b8d45b7d7c9413bffafc2b0cd1f052a59a1af"
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

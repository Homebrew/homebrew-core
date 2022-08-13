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
    sha256 cellar: :any,                 arm64_monterey: "20cf06d480c614636c57f448d675a60082a2661281e6f92df5960fb7320af1b9"
    sha256 cellar: :any,                 arm64_big_sur:  "9be8c4f798473371aed50a01c76b347af44087c60475b8d4f0089833b1498243"
    sha256 cellar: :any,                 monterey:       "153c91b26950bcedfd25e2540d6921d5ddc49f9411f7e4ee4cfc0bb69b9e359b"
    sha256 cellar: :any,                 big_sur:        "3e89be607cbed4696cb85d185a0b52a8616b8adcb716e4ba840e4cd8f4d94790"
    sha256 cellar: :any,                 catalina:       "c6791affb7691cbfe035cf59f7c1a496474f31b1554df318d6e111d920d70901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d55bccb3c374b2e9426cf7c38fe0d1c21a5e34a5dbcbd11b14d7a49b4ef90d"
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

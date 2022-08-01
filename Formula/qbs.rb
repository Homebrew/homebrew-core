class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.23.0/qbs-src-1.23.0.tar.gz"
  sha256 "c86aa775446aec728bcbbed782ec128f4e6e2c26536710017343e684bb616d7a"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "739cff370d75fe1110290d9f3f1b7ca4c578aae27890d44a47af02801c654670"
    sha256 cellar: :any,                 arm64_big_sur:  "e311c98d4d8d8dbb647448ccdb991b3e4d847d09ff00dfa66f7577acb9628da1"
    sha256 cellar: :any,                 monterey:       "e9b21e081c886fd6dac1943e5273dc77b39555f3ad662b19e9bd8aeda7817cb4"
    sha256 cellar: :any,                 big_sur:        "f682af236f0aa85b53667b7746f4af72e9e1f8cc6b9538c0a681ccc37eb168a8"
    sha256 cellar: :any,                 catalina:       "11c47e011c05e23430cead51bf023a7bf8e75949f06304338e82c7f265d874b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "871d62e3ac8fd5e9409f819a9a9f555ba21be21e5636c54841bb387c2c082c7e"
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

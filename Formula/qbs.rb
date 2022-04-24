class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  stable do
    url "https://download.qt.io/official_releases/qbs/1.22.0/qbs-src-1.22.0.tar.gz"
    sha256 "ebfd4b4f115f7ad235477ddf74cc7216dfa66b6166372dc0be454691078f9f3e"

    # Fix Xcode support for 13.3. Remove in the next release.
    patch do
      url "https://code.qt.io/cgit/qbs/qbs.git/patch/?id=d64c7802fef2872aa6a78c06648a0aed45250955"
      sha256 "cccc3fc3a00ddd71e12ad7f89d4e391c476b537719ba904a3afc42e658df4313"
    end
  end

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d25684d484d6d72528248a8fc04f48172e86a6627010a67c82dc12f935224011"
    sha256 cellar: :any, arm64_big_sur:  "9ba4c82c358e5374c06ec726014a50bf56533eb7b81c4fdbb37815da16ecaac5"
    sha256 cellar: :any, monterey:       "5c4f0669be6779f00f7f2332ca196ccbfeb35cfc0ddc6ed0592500d581fadf3d"
    sha256 cellar: :any, big_sur:        "4af6da2dade9b8aa140d80808d7f51b7730ce7f0fac6db2658b20994eaf36c2a"
    sha256 cellar: :any, catalina:       "b82a2d921e75e74140b84d3093a1bf0138c7ab395043afba89f7adbb21efdb08"
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

class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.0.0/qbs-src-2.0.0.tar.gz"
  sha256 "d78555691ea732949346860e56f68c7c44e9384011359722b032a49b52dfccfd"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18d2fbd79783a3ba44d4447edffdc6fe7616137b36f5bc88a0e2cf6b4e4cc390"
    sha256 cellar: :any,                 arm64_monterey: "e73d01152f0ceedf382cdd76362f9c042d6cfaf18020a3be643f60350539c446"
    sha256 cellar: :any,                 arm64_big_sur:  "bbc4bed754f479d535ebef992c10efee77ed5138f2d85577cafe88e8746799ac"
    sha256 cellar: :any,                 ventura:        "32d62ed2dcd5ad235a30d50a0641e09dff7ead681c01f21156dbae54e940aa86"
    sha256 cellar: :any,                 monterey:       "67247217f821318fedcae83bd973c2ece4a83834206fe6536c0f968dc5e7d0a8"
    sha256 cellar: :any,                 big_sur:        "a45cccc55f10b4522391b5b836f2687886516a82047ab3c990a1e49f689daf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced3c8a4949c0123cd21fa5c9cbd4515eb1befdae06df9a77ab75c18dc857762"
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

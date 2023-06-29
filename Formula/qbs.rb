class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.0.2/qbs-src-2.0.2.tar.gz"
  sha256 "ddef1a6bfa6c7bf52b9f87a8cb0f1a940973031ad408529156070411beb9c19b"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18997f432413377d11df90aa997196647b347a9e9c36d3b0ee26a3ad4f9c5360"
    sha256 cellar: :any,                 arm64_monterey: "701d2e02c55678dd53d032ca367815391636cd6c0dbc9f6b3c9ed91092f3ef8c"
    sha256 cellar: :any,                 arm64_big_sur:  "1e670f33bf611916ce7e43ca995cda1cd6cff8e842ce146b052318b4cedaeea9"
    sha256                               ventura:        "d93f52b643d4663815dd3ada9b71c4325881d7bd1f5601570d307ea6feb9f85d"
    sha256                               monterey:       "14ee556aa4a7991312acd3c03e63fc641383587c37a50a60096358f10da4ccac"
    sha256                               big_sur:        "39aa338fdd27d7d389d7fb0b3ddb1056855984bd52021c137a059eba7864a440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e3af02954a3fafd1bed4bde13cdadd95ae5e22ff8d6ec5c90f7211fdb1b226"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
    qt = Formula["qt"].opt_prefix
    system "cmake", ".", "-DQt6_DIR=#{qt}/lib/cmake/Qt6", "-DQBS_ENABLE_RPATH=NO",
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

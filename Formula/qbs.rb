class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.0.1/qbs-src-2.0.1.tar.gz"
  sha256 "475a170fc4a117c2a93b30356f3c884eb73059b2cb06fed9f090a5f679aa5555"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddffb52b4417d93db9e9b64d9e5162b552e9057f55a07dfe277ba722936b0b01"
    sha256 cellar: :any,                 arm64_monterey: "f49f5cec2a71308d379a9c2187223d2c196df8a846797a8cb8a1d2f5d6227343"
    sha256 cellar: :any,                 arm64_big_sur:  "63afc02ca094e8e50f9c30312457aa7e615da9a4667152c4bf3a1d479cd81bff"
    sha256                               ventura:        "3cf228abbd3489f67239d139b699684f19f66f9b9108845cc0cd35c6a29bd261"
    sha256                               monterey:       "adfe5878e0cf05b624f3dee18af7fd71cea3baf6e32cbb59b06c47784150b6a9"
    sha256                               big_sur:        "b34e41f31b10ab6f91757f79b2ff7d5d96e46bfc314be8168cf76b4484263da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e835374a96be2d53675949ac41ad2cc12a7d68ff196e25d1a2808822ea35bb4"
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

class Qtremoteobjects < Formula
  desc "Provides APIs for inter-process communication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtremoteobjects-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtremoteobjects-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtremoteobjects-everywhere-src-6.9.3.tar.xz"
  sha256 "98987c0055d4e1a6d31dac85c3445d99ed8142c21995f70b391ef0ebafaad85b"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # repc
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtremoteobjects.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "577d93ff23c63974f04bf0ce68b5301944deff455e49a3cc7123dcd596a12dbb"
    sha256 cellar: :any,                 arm64_sequoia: "c780c6033c163f66e55a4cf19a6cf2312323008517352977885c69fa5be0a94c"
    sha256 cellar: :any,                 arm64_sonoma:  "135cda0ed437bd28a541d0ac7430f2bf2b1764aebedd1a9f5a5f1501a5b0f90e"
    sha256 cellar: :any,                 sonoma:        "feec346ed5396597e88c0a4a2a7717247a903318760118298c550af9674faffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71ac89d7ba9469e98f644f85817cbd616949543a1c492f21970d5bf5b9cf85c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfc7c94c958908102f324514ebb26bcce192383c5554aec6329f85ae1134d5c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS RemoteObjects)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::RemoteObjects)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += remoteobjects
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QRemoteObjectRegistryHost>

      int main(void) {
        QRemoteObjectHost node(QUrl(QStringLiteral("local:replica")));
        QRemoteObjectRegistryHost node2(QUrl(QStringLiteral("local:registry")));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6RemoteObjects").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

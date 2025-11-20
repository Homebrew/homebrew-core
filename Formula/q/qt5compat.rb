class Qt5compat < Formula
  desc "Qt 5 Core APIs that were removed in Qt 6"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qt5compat-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qt5compat-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qt5compat-everywhere-src-6.9.3.tar.xz"
  sha256 "091dac2124c2291c3566408720f89b1796cd458897c6acabd11f03976ad04461"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-2-Clause", # src/core5/codecs
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  head "https://code.qt.io/qt/qt5compat.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce93f386ed3c06ebb79bd28c95d54048906f7c612edadde62636f373e613e3ab"
    sha256 cellar: :any,                 arm64_sequoia: "6da7197e5ff3c57dda2576e15e60696751cdc7919ca314623737fbd5203ae8d8"
    sha256 cellar: :any,                 arm64_sonoma:  "5744ccf277387c8717b3c92ff9e4aea24f168bc96c0ceb39e9e5633868bebfbd"
    sha256 cellar: :any,                 sonoma:        "23170df3660993e31acd206497d54cb3d84b219ab9bf23cb975f02dc1052bf63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d2379c746dcafffc48d54113417cea1e6139b2d1ef1270377ce481900a5cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae5705dbc6a3bd119c7b54b407364a248624cf020305233a345d2b9dfbbf701"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "icu4c@78"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtshadertools"

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
      find_package(Qt6 REQUIRED COMPONENTS Core5Compat)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Core5Compat)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += core5compat
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QChar>
      #include <QString>
      #include <QStringRef>

      int main(void) {
        const QString hw = QStringLiteral("Hello World");
        const QStringRef ref = QStringRef(&hw).mid(6);
        Q_ASSERT(ref.at(0) == QChar('W'));
        Q_ASSERT(ref.at(4) == QChar('d'));
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

    flags = shell_output("pkgconf --cflags --libs Qt6Core5Compat").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

class Qtwebchannel < Formula
  desc "Bridges the gap between Qt applications and HTML/JavaScript"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtwebchannel-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtwebchannel-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtwebchannel-everywhere-src-6.10.2.tar.xz"
  sha256 "e31ea59f8e19e0374d54fdc7a8479c840acffc4ba5297ee43564b5158a4f2c27"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtwebchannel.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc96f30d46fbebcda16715d54b63de79b296d69819ac47919caaa834103c9e0"
    sha256 cellar: :any,                 arm64_sequoia: "01f0995a0acfcdc6a92b60008e9648d9cb73414305cd211113ca403aab127fe0"
    sha256 cellar: :any,                 arm64_sonoma:  "53a67dcb59ffb690b4cc7f80d77ebeb2bb94d5bfacee122dd9300e284cbd2934"
    sha256 cellar: :any,                 sonoma:        "1c9c455b3a52de0bf21303fbddbc985ec00ed4198d74ad8118a93c3612b4e645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d34f231fd171997a9d223fdd5d359fd284f31a008e12bf1918e74ee4c6f0599c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a295c165ccea3eb0c07d0370f2e41f04742a5c330ca079f827ff961cc4db0f5"
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
      find_package(Qt6 REQUIRED COMPONENTS WebChannel)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::WebChannel)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += webchannel
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QHash>
      #include <QObject>
      #include <QString>
      #include <QStringLiteral>
      #include <QWebChannel>

      int main(void) {
        QWebChannel channel;
        QObject plain;
        QHash<QString, QObject*> objects;
        objects[QStringLiteral("plain")] = &plain;
        objects[QStringLiteral("channel")] = &channel;
        channel.registerObjects(objects);
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

    flags = shell_output("pkgconf --cflags --libs Qt6WebChannel").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

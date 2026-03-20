class Qtremoteobjects < Formula
  desc "Provides APIs for inter-process communication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtremoteobjects-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtremoteobjects-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtremoteobjects-everywhere-src-6.10.2.tar.xz"
  sha256 "bc683f044fe74dcf06c2b47f31fff2d967b5ac81896620108697dcc942eb65cd"
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
    sha256 cellar: :any,                 arm64_tahoe:   "bbf6e8b5067913cb8ca8da629964edb7f972607ef4e1efe098700d055c475dd6"
    sha256 cellar: :any,                 arm64_sequoia: "e0326c5649e3aba0b8aa3d8ce73a9011f92713d1331555117161dca0454a2034"
    sha256 cellar: :any,                 arm64_sonoma:  "2b0af04f141feccf12466210a6a266e2aa6d959a2482313bee0547f4ab073320"
    sha256 cellar: :any,                 sonoma:        "b49f73a6038da415e73f2da82012ef07053de6eb89825c075728893eef24fce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89a822f38906be46844ba50e1c681b235a7463ce0bcb0fe5426887d9a8fc0dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a961e7bf4f22b39ff5a6ffdd6b92cb8cf8f0bc3f3edec5e29b39fda802b83d8d"
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

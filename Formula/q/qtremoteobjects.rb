class Qtremoteobjects < Formula
  desc "Provides APIs for inter-process communication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtremoteobjects-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtremoteobjects-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtremoteobjects-everywhere-src-6.11.1.tar.xz"
  sha256 "40629895c69531a687a9c0258316cee3f04c2d18b2bf2ad36dc83e76a58f111a"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # repc
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtremoteobjects.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab2db40d8b166d62f5ff0178ebc1720ad932f2ebdaac3e6be2407409fc36eb8f"
    sha256 cellar: :any,                 arm64_sequoia: "0324cdc19f0709b14b8ba4bca89a9cab1ad5bf1e4312c628faf568409dd2b80c"
    sha256 cellar: :any,                 arm64_sonoma:  "a302cd6cdd644da611d5b1cfd76135008047dac314dc4d41caa9c5267d6b66ed"
    sha256 cellar: :any,                 sonoma:        "7b9f486fb587259048acea9b07aa25efce4dcd1e62bfed5bd418e3b836f1cc68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f38c5601de06c86d413e8139b5d75245d38d2d4debb17dc70b65de368c40305e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53f53386c1e2062d700736383a4f11c831fcde327509e489dd44ebe3e81f0bb"
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

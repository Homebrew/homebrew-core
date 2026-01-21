class Qtremoteobjects < Formula
  desc "Provides APIs for inter-process communication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtremoteobjects-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtremoteobjects-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtremoteobjects-everywhere-src-6.10.1.tar.xz"
  sha256 "7c9e56dbe2c400e33d13626a27d822a7c95b7d95f2272b198a788c2b4a9b8a0d"
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
    sha256 cellar: :any,                 arm64_tahoe:   "86ee715b7d7b00c4d15edffa1702ec44b477a811598d4b69835f53db16bbc802"
    sha256 cellar: :any,                 arm64_sequoia: "b58536094053ba7c2e7ba5b5e0b651cf4e5ae33f5ca9569247654c824fc95fcb"
    sha256 cellar: :any,                 arm64_sonoma:  "7d9eb770d3eba9329bac767dd3c6bd8d44b8c572795631a1bad2f54c9b3e8da2"
    sha256 cellar: :any,                 sonoma:        "9105b1712049b583f5854d28f6ce36e306effa7872829b6c1a014ea041eacef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d495fe936821d2aebfd812a454ca2133372372cb39b5fab1443d25b339561c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb01566f07bc5d630e76756a910d75d3bde94cf35c45a1c7da153421ad5f9355"
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

class Qtwebsockets < Formula
  desc "Provides WebSocket communication compliant with RFC 6455"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.0/submodules/qtwebsockets-everywhere-src-6.10.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.0/submodules/qtwebsockets-everywhere-src-6.10.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.0/submodules/qtwebsockets-everywhere-src-6.10.0.tar.xz"
  sha256 "d1092e7da5c3b8eea242e4069f05ff8e710a17c54d5010c1b557e26f7948806e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtwebsockets.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c0745d53faad96232dc00ca9e99986c2fa8ef7dd93eafba68c5f9614f74dc00"
    sha256 cellar: :any,                 arm64_sequoia: "51a3bd0223bc2472f370c60de5151366c15a52b9ef05d1df98076e871c84461c"
    sha256 cellar: :any,                 arm64_sonoma:  "99965065d7ee4c646633336483a7ce97124f55658326017b13999de9afc26941"
    sha256 cellar: :any,                 sonoma:        "2211cf78134662aa53afeda76d7445eb12d9d280cbe80ae2e7baa659f720fcb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbae2e1155b0b2ab9bcfebbf55c60501705c0f77862458fc8a021a1d4e1da9a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e652918f94cbdc8373635652e4bcabec4219b6548e8c3f61d53e922b65417c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"

  # TODO: preserve_rpath # https://github.com/orgs/Homebrew/discussions/2823

  def install
    args = []
    if OS.mac?
      args << "-DQT_EXTRA_RPATHS=#{(HOMEBREW_PREFIX/"lib").relative_path_from(lib)}"
      args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS WebSockets)
      qt_standard_project_setup()
      qt_add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::WebSockets)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += websockets
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtWebSockets>

      int main(void) {
        QWebSocketServer server{QStringLiteral("Test Server"), QWebSocketServer::NonSecureMode};
        Q_ASSERT(server.listen(QHostAddress::Any, #{free_port}));
        server.close();
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake", "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6WebSockets").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags, "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    system "./test"
  end
end

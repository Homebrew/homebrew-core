class Qtscxml < Formula
  desc "Provides functionality to create state machines from SCXML files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtscxml-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtscxml-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtscxml-everywhere-src-6.11.0.tar.xz"
  sha256 "6c383a53c0c3668fcc80d89f00193f0e928a784199c591213cbed1bf2f64d4e7"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qscxmlc
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtscxml.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cd590704c903e606974fb9a0a6678db06827e37f10151a693d30cfeacb93be85"
    sha256 cellar: :any,                 arm64_sequoia: "b946a3027100bf2f64af05aaa1a5caf9e6e6be3facfa6a8a0b01f465ee1dd5de"
    sha256 cellar: :any,                 arm64_sonoma:  "8ec360b3c1aa18d3ab94c43f7aea892b4089e910a484be6a308ba9cf5626c7a8"
    sha256 cellar: :any,                 sonoma:        "63b2b467900d1dcba2b132651dc34dbae987e36848113aa6f24807d2a6614248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99a59e6b6d29f8402ee51c0e8a973fa93845dda8b550ae386ea9146deea7864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "465f85cf1484cdef828c6328fe6a9ecca898f414709d9448b95e86a386046185"
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
      find_package(Qt6 REQUIRED COMPONENTS Scxml)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Scxml)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += scxml
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"statemachine.scxml").write <<~XML
      <?xml version="1.0" ?>
      <scxml xmlns="http://www.w3.org/2005/07/scxml" version="1.0" initial="a">
        <state id="a"><transition event="step" target="b"/></state>
        <state id="b"><transition event="step" target="c"/></state>
        <final id="c"/>
      </scxml>
    XML

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QScopedPointer>
      #include <QScxmlStateMachine>
      #include <QString>

      int main(void) {
        QScopedPointer<QScxmlStateMachine> stateMachine(
          QScxmlStateMachine::fromFile(QString("#{testpath}/statemachine.scxml")));
        Q_ASSERT(!stateMachine.isNull());
        Q_ASSERT(stateMachine->parseErrors().isEmpty());
        auto states = stateMachine->stateNames();
        Q_ASSERT(states.size() == 3);
        Q_ASSERT(states.at(1) == QLatin1String("b"));
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

    flags = shell_output("pkgconf --cflags --libs Qt6Scxml").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

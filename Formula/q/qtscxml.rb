class Qtscxml < Formula
  desc "Provides functionality to create state machines from SCXML files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtscxml-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtscxml-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtscxml-everywhere-src-6.11.1.tar.xz"
  sha256 "8e495245e5d1fe75de612c8a07e4043635407a1979bb1dd588f1751d1390203f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "60d0280424a2e901869fcffb99ba99bac966c2ca4da32df15f541e06195a0636"
    sha256 cellar: :any,                 arm64_sequoia: "aa0866441cceea9086cfb79d73c312932d2c56c4d395742f595030c0dcb5cf88"
    sha256 cellar: :any,                 arm64_sonoma:  "25091bd29a1743a87072e37d1a91ff28d5e09b614b90e405acd74e4bbff27943"
    sha256 cellar: :any,                 sonoma:        "28b5d7545f4d6c14f1eb3928ce0e76ef4ec9ba7d3a2c05ecc375de1aad2b7ef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a1e62e347a76126f157285bd3ede9d067d6ea02bc8ef452b008a81fb366d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091b04a37cb8bb3b18219ef2e975088834bbc260c9109a4263b16834703d4bd6"
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

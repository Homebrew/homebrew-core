class Qtscxml < Formula
  desc "Provides functionality to create state machines from SCXML files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtscxml-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtscxml-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtscxml-everywhere-src-6.9.3.tar.xz"
  sha256 "f389c0c051df908eae392fbe94a8513e6fe15f88399d88fd33a763165f5b34b7"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qscxmlc
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtscxml.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c723564b1130e6030944d3eb19b844e169b0768380f8e4e91044540eb609b3a"
    sha256 cellar: :any,                 arm64_sequoia: "004c40cecb4b10056eb19a8e47637d9c00b58160735c255507930b72741ce927"
    sha256 cellar: :any,                 arm64_sonoma:  "95663d1f120f49b7d62c4dbe805004c2d888f4e1c19c1b7ecf316bd880972759"
    sha256 cellar: :any,                 sonoma:        "46b06c2375955e2ee1e7597006f1eb3cdf55fbf660f10c8cb5a3fd6f28853cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c278705537169c0689b35dc2875eda465d9b7c6aaeb7c0a1ae17e93ca5f27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e883ccfcb801ac56233c52c5d15c05ae8e290dd3a24c049e87be34eddba9ecb"
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

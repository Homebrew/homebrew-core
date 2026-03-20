class Qtscxml < Formula
  desc "Provides functionality to create state machines from SCXML files"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtscxml-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtscxml-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtscxml-everywhere-src-6.10.2.tar.xz"
  sha256 "0f9c178db3f1b1b06d20172aaaa4d7f5513bcb99de01f880c29e23b5ffdd236a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "2b869d1f7717baa90b0d1a6331edd1f8cf5c87a871c54066e0246cb659d07191"
    sha256 cellar: :any,                 arm64_sequoia: "e4fafc8f713f6ebb19a40083d9b7b488cf960959bc61f34a4af24558a584de3b"
    sha256 cellar: :any,                 arm64_sonoma:  "fa210670a0846010df327a81a767e975f328074f3ecc067c1885b718d590ace8"
    sha256 cellar: :any,                 sonoma:        "b598c56b0de80af53de2a4f418613681e0b3a4919d0d8ba17b014da8df71b5ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ff03b11dc64d6f0bb74d60bd87b7a62897619680df448caf22de1bd3418ba7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1e8bcfa1cc8d21a56e3b2684269b4d5907c59ec403f01269ffd48e576f077b"
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

class Qtlocation < Formula
  desc "Provides C++ interfaces to retrieve location and navigational information"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtlocation-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtlocation-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtlocation-everywhere-src-6.10.2.tar.xz"
  sha256 "d313f05dedc593517c47d0fa3eb131a2597c01db23de263fe89fea561be50f3c"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlocation.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8495d6034db0d2b568779b0a8bfa73c9386425dcb9a46b14123e662f0e036a54"
    sha256 cellar: :any,                 arm64_sequoia: "e3e88f8d7529fc644dd57ecf6f918715f81767b2d0c744c51499d2dbe4e9ea87"
    sha256 cellar: :any,                 arm64_sonoma:  "8013e0f81b65c9ec151b1647c39ec0f24bdb6e01f713823cde54ed97a96b09e0"
    sha256 cellar: :any,                 sonoma:        "ecaf0b90635659bb22c7d2459381e579b6ad3b97d1cffc1050483f50abbf605d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654baac9736673a8b0a256b84f1e10224e265857aefd76314cdefa144cb4c061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feedcf761093383a84ef3b25ff0cad9eba3c036180dc653b5b241c5e1e16711d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtpositioning"

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
      find_package(Qt6 REQUIRED COMPONENTS Location)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Location)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += location
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QGeoCoordinate>
      #include <QGeoLocation>
      #include <QPlace>
      #include <QPlaceAttribute>
      #include <QStringLiteral>

      int main(void) {
        QPlace testObj;
        testObj.setPlaceId("testId");
        QPlaceAttribute paymentMethods;
        paymentMethods.setLabel("Payment methods");
        paymentMethods.setText("Visa");
        testObj.setExtendedAttribute(QStringLiteral("paymentMethods"), paymentMethods);
        QGeoLocation loc;
        loc.setCoordinate(QGeoCoordinate(10,20));
        testObj.setLocation(loc);
        QPlace *testObjPtr = new QPlace(testObj);
        Q_ASSERT(testObjPtr != NULL);
        Q_ASSERT(*testObjPtr == testObj);
        delete testObjPtr;
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

    flags = shell_output("pkgconf --cflags --libs Qt6Location").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

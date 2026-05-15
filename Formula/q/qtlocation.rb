class Qtlocation < Formula
  desc "Provides C++ interfaces to retrieve location and navigational information"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtlocation-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qtlocation-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qtlocation-everywhere-src-6.11.0.tar.xz"
  sha256 "89b8386a8ae9e0b40a43fad398ac344f93a3b0d22f09bec4631f25d79135abef"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtlocation.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de3505f0928be85af32b8386792ffdad6a7e235071f3b32a0185e5deafb154b4"
    sha256 cellar: :any,                 arm64_sequoia: "4def21538efe571756056de99bfe29f0f5b0499d908542c81884f191adc61491"
    sha256 cellar: :any,                 arm64_sonoma:  "df9157dcde50817ec00cf5d9b43a1f85d570d0f579f68e3d7e1f7bb1c88e63ab"
    sha256 cellar: :any,                 sonoma:        "6d3d851f442d4c358028a70d1e3dab64e147ced7ed4041ec6317810a0ef12fa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3091b2374b12cf8cb6ca6e0f6165a2de612b2a4158554027367b546b31b4d458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cd787802301ee6c6b50d9296010ab6a6c0c314f9ae18735a3c7598d0234039"
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

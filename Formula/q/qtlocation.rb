class Qtlocation < Formula
  desc "Provides C++ interfaces to retrieve location and navigational information"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtlocation-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtlocation-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtlocation-everywhere-src-6.11.2.tar.xz"
  sha256 "4d50a7ece01fbd76f6ec17c650236cb56ea60f987c52fc391dac72f13f65c23a"
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
    sha256 cellar: :any, arm64_golden_gate: "5a6c8086b7684f6a3a0b196ba6d91bf8a9660fa4ea5f046704365743fcb0d4f7"
    sha256 cellar: :any, arm64_tahoe:       "184f3151b557a4589bf04138a175cc04e56596b3e0351318ad76bbdaf6a87a80"
    sha256 cellar: :any, arm64_sequoia:     "ac456df31c1750b6080bb6605db39b00a1c30162e7270f251026e78c774047cd"
    sha256 cellar: :any, arm64_sonoma:      "5c8f22243c88e863ed7f37993c501b2468061a29ede3b46d5228d8e34ffa3dce"
    sha256 cellar: :any, arm64_linux:       "e80ca51a31d387fd1a042921e54326270b38ae59a724c3ea5defe5ebd7b6101a"
    sha256 cellar: :any, x86_64_linux:      "4b3471f7920ba64abad7d9a0b010c15fbb5b4e134c885b32b92e1cc52f3dd7ed"
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
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Location").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

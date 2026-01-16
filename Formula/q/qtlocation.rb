class Qtlocation < Formula
  desc "Provides C++ interfaces to retrieve location and navigational information"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtlocation-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtlocation-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtlocation-everywhere-src-6.10.1.tar.xz"
  sha256 "2b9618f1b99cdc51d6697a79f3a57f4c2b629711549912067db8cd2b40794f09"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlocation.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "232fc7a036a87eae756a030593e3b5612bb92b059a161f4e4a5a45f66d3f9d7d"
    sha256 cellar: :any,                 arm64_sequoia: "8e22d020d4f032eb20bd8c59a3e0a254f9c02a988456bad4e2e83657ce11759e"
    sha256 cellar: :any,                 arm64_sonoma:  "4d57df2b86a3f52d6e13f6653e4f5a29994282064d1cb27c21422dac7abb769d"
    sha256 cellar: :any,                 sonoma:        "c04dee7e96ced16cf7dc2830f50e7da821731a10ea7f211001ddce5740db2188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7983537520a5c73722a9965e044f06fa7ed2bff3a58d61c0c8cd3961e8ae17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e342b5229f106167b8f229a6ca4eea578f51eed9100b7bb6b7faa9abcc6036"
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

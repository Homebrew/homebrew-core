class Qtspeech < Formula
  desc "Enables access to text-to-speech engines"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtspeech-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtspeech-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtspeech-everywhere-src-6.10.2.tar.xz"
  sha256 "d937f6c715792b0d8f036e94513ebfc8def6b988a65f3ff30a7f4a8cc1263014"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtspeech.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebd9ea8d8aa2172fc035003b5c8acf861e8f7179ead216f2a4330cafdc484aca"
    sha256 cellar: :any,                 arm64_sequoia: "5b85513ba32852144a9bdb4e45d994489372a6c8ef687219dcfd052e5b3daac3"
    sha256 cellar: :any,                 arm64_sonoma:  "c9756a5f9e5b9d5e00855743a998da1a5382357354fd229849eb2f6383b86977"
    sha256 cellar: :any,                 sonoma:        "794c1bd0400d2cfbe63bca3c278212c4a6dae91c8a74f4605236a03a6bec1937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31e57cb709b74f6b896c1c5945e725ab7251ac16efa3bc6061692968f55305a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d5d3eda3b138744045992452bdcc993c033da36c498ede60b714097cffb8010"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtmultimedia"

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
      find_package(Qt6 REQUIRED COMPONENTS TextToSpeech)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::TextToSpeech)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += texttospeech
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtTextToSpeech>

      int main(void) {
        Q_ASSERT(QTextToSpeech::availableEngines().contains("mock"));
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

    flags = shell_output("pkgconf --cflags --libs Qt6TextToSpeech").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

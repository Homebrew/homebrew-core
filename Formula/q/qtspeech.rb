class Qtspeech < Formula
  desc "Enables access to text-to-speech engines"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtspeech-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtspeech-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtspeech-everywhere-src-6.11.1.tar.xz"
  sha256 "c035c318012025875a653245701a23d3807e8e46b8bf7987877842219c273f14"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtspeech.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "799ae8c9b034e0ecf2a433a04b9d10d00d31cb4cf7e3bedc879afd74408d482e"
    sha256 cellar: :any,                 arm64_sequoia: "43f53ffaa22c4867460da26b293f2b31a664bda2eed5956669a9536dbacd79b0"
    sha256 cellar: :any,                 arm64_sonoma:  "08e43dc67d41bd364cb53465ab5f5d62068f73a2fd1867a9e198143dba890e51"
    sha256 cellar: :any,                 sonoma:        "e2be886661f4b536493cb7d8c91a40360b6464807565fb8c6fe5c23b126d36ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "541ce878ee7b9ddf1c9edce31e4dbff0b18348b2a495052ba8b148e526943bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8bc115956e71d2d9b9d311d1c94158a199dd38b71d44d545eaeb0c646885775"
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

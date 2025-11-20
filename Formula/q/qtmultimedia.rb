class Qtmultimedia < Formula
  desc "Provides APIs for playing back and recording audiovisual content"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtmultimedia-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtmultimedia-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtmultimedia-everywhere-src-6.9.3.tar.xz"
  sha256 "a275bee7ea60c91851236acdf99d76b891da90f428b68f51fe332354f19b86f5"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { all_of: ["MPL-2.0", "BSD-3-Clause"] }, # bundled eigen
    "Apache-2.0",   # bundled resonance-audio
    "BSD-3-Clause", # bundled pffft; *.cmake
    "GPL-3.0-only", # Qt6MultimediaTestLib
    "MIT",          # bundled signalsmith-stretch (Linux)
  ]
  head "https://code.qt.io/qt/qtmultimedia.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c98117497f1e2f5bd945d05bc3b3f067d7bd5bd3c905f48d702f3ea57805d2c"
    sha256 cellar: :any,                 arm64_sequoia: "6b3f315f1376b882bbaa53ae8aa1e2332f4d59bfb3dfdc66707f960f7062792d"
    sha256 cellar: :any,                 arm64_sonoma:  "2e907662de15c622360bc5b660cbf65161b6751f4014ec32cc0fe1c2d985b545"
    sha256 cellar: :any,                 sonoma:        "d3e94fc3374bd95e2239c636fd8919153d9a1211844070993086b373d98218ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8091085974b33f71688fda156e04ac91ff9c62e87334f4464746cc7a6b96dfe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbdada04e1d7ec73800531f1f3bd52a9f6bea16f12b54e8ceb12f3b4b64b31f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qtshadertools" => :build
  depends_on "vulkan-headers" => :build
  depends_on "pkgconf" => :test

  depends_on macos: :ventura
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"

  on_macos do
    depends_on "qtshadertools"
  end

  on_ventura do
    depends_on xcode: ["15.0", :build] # for `@available(macOS 14)`
  end

  on_linux do
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "gstreamer"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "pulseaudio"
  end

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    if OS.mac?
      args << "-DQT_FEATURE_ffmpeg=OFF"
      args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    modules = %w[Core Multimedia]

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += #{modules.join(" ").downcase}
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <QCoreApplication>
      #include <QAudioDevice>
      #include <QMediaDevices>
      #include <QTextStream>

      int main(int argc, char *argv[]) {
        QCoreApplication app(argc, argv);
        QTextStream out(stdout);
        for(const QAudioDevice &device : QMediaDevices::audioInputs()) {
          out << "ID: " << device.id() << Qt::endl;
        }
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

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

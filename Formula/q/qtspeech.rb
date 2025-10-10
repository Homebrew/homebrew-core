class Qtspeech < Formula
  desc "Enables access to text-to-speech engines"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.0/submodules/qtspeech-everywhere-src-6.10.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.0/submodules/qtspeech-everywhere-src-6.10.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.0/submodules/qtspeech-everywhere-src-6.10.0.tar.xz"
  sha256 "13033066830ccc8be50951e3a2f2564c712e5f5e9b0af4e1040184f1a64aa51e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtspeech.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ade8f12a77ecc4e7a9fec711f8edd06d6bc9c151cb6c4b2425f3ab2182601cc7"
    sha256 cellar: :any,                 arm64_sequoia: "5ed7f091c061e87dafff8a91d1133b975b3e7f2da8490e7d01fe409483c46125"
    sha256 cellar: :any,                 arm64_sonoma:  "de34302e9338a9ea4b837526d5fb8df7310ebda11caf609bc0834811b9c29cc2"
    sha256 cellar: :any,                 sonoma:        "e10253cae4f4c384f17743fd8750d66b3589bd20c56bf203990be678ae25de62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edae18bb214bc1d6821d72d030dd5398dc0411b76f3decd6d36aba700ecda803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1855d1dd465f4f8c9ab8a8f6bec354b5ca062794d072b6d0eb21438d4478683"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtmultimedia"

  # TODO: preserve_rpath # https://github.com/orgs/Homebrew/discussions/2823

  def install
    args = []
    if OS.mac?
      args << "-DQT_EXTRA_RPATHS=#{(HOMEBREW_PREFIX/"lib").relative_path_from(lib)}"
      args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args(find_framework: "FIRST")
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
      qt_standard_project_setup()
      qt_add_executable(test main.cpp)
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

    system "cmake", "-S", ".", "-B", "cmake", "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6TextToSpeech").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags, "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    system "./test"
  end
end

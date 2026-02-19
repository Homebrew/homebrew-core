class Qtnetworkauth < Formula
  desc "Provides support for OAuth-based authorization to online services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtnetworkauth-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtnetworkauth-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtnetworkauth-everywhere-src-6.10.2.tar.xz"
  sha256 "4f29fd9e4b505f5714fc42296b04c701f66ced185c49de4d520cb8de4b1981b3"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtnetworkauth.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2726598a83e50ecf146240f72b3f15fdef9ee095d5328bfa9d8293ff2419b080"
    sha256 cellar: :any,                 arm64_sequoia: "21176c36003436a12d94b980635d55b3c4fd78f3c012da4d42d132e1b3588a53"
    sha256 cellar: :any,                 arm64_sonoma:  "df7c1c168f01eb3625e7c95ce0dda2fcd43292bb8188727600ec4ecdebdbf534"
    sha256 cellar: :any,                 sonoma:        "e8a9beab36dc63168b62e37fbd44a61c07b15579cffb12fc747a91e02f437cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5e9318edc921c269d495c79bcd7873d438afd72013c2fd5127338e844480bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f070b6f45e18494587396cedf37f8942028e57d2c944707484513d04d69ae82"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

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
      find_package(Qt6 REQUIRED COMPONENTS NetworkAuth)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::NetworkAuth)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += networkauth
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QHostAddress>
      #include <QOAuth2AuthorizationCodeFlow>
      #include <QOAuthHttpServerReplyHandler>

      int main(void) {
        QOAuth2AuthorizationCodeFlow oauth2;
        auto replyHandler = new QOAuthHttpServerReplyHandler(QHostAddress::Any, 1337);
        oauth2.setReplyHandler(replyHandler);
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

    flags = shell_output("pkgconf --cflags --libs Qt6NetworkAuth").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end

class QtNetworkauth < Formula
  desc "Qt network authentication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/additional_libraries/qtnetworkauth/6.0/6.0.0/qtnetworkauth-everywhere-src-6.0.0.tar.xz"
  sha256 "83fa07b7a76537220e9b16b92c24abb4633f14f5be6c16ad706795ddd181c7e8"
  license "GPL-3.0"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qt6"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.16.0)

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Network NetworkAuth REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Network Qt6::NetworkAuth)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core network networkauth
      QT       -= gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtNetworkAuth>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        auto p = new QOAuthHttpServerReplyHandler();
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"

    ENV.delete "CPATH"
    system "qmake", testpath/"test.pro"
    system "make"
  end
end
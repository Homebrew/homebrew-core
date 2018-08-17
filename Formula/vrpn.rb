class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.34/vrpn_07.34.zip"
  sha256 "1ecb68f25dcd741c4bfe161ce15424f1319a387a487efa3fbf49b8aa249c9910"
  head "https://github.com/vrpn/vrpn.git"

  bottle do
    cellar :any
    sha256 "a254843eaac154ae39da044efacb4725c8028e42914c4fb10cc7d524b6ecd7d0" => :high_sierra
    sha256 "3f392e7ab5c352a3da3e60795a4255280cd8a53e2110e588eac2fb9c910685e0" => :sierra
    sha256 "b9a6caa7c8ac287479ef8a09bd54362a56b73fe80b8aac1a233864be97fc1567" => :el_capitan
  end

  option "with-clients", "Build client apps and tests"
  option "with-docs", "Build doxygen-based API documentation"

  deprecated_option "docs" => "with-docs"
  deprecated_option "clients" => "with-clients"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "libusb" # for HID support

  def install
    ENV.libstdcxx unless MacOS.version > :mavericks

    args = std_cmake_args
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"
    args << "-DVRPN_BUILD_JAVA:BOOL=OFF"

    if build.with? "clients"
      args << "-DVRPN_BUILD_CLIENTS:BOOL=ON"
    else
      args << "-DVRPN_BUILD_CLIENTS:BOOL=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "doc" if build.with? "docs"
      system "make", "install"
    end
  end
end

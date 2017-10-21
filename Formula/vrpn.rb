class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/v07.33/vrpn_07_33.zip"
  sha256 "3cb9e71f17eb756fbcf738e6d5084d47b3b122b68b66d42d6769105cb18a79be"
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

  # Upstream commit fixes Xcode 9 build failure, remove in next version
  # https://github.com/vrpn/vrpn/issues/187
  patch do
    url "https://github.com/vrpn/vrpn/commit/855af40d.patch?full_index=1"
    sha256 "601335e211cee722814650a6a31cfc6a4278ae52d5e9527a2799df3dd47758b9"
  end

  def install
    ENV.libstdcxx

    args = std_cmake_args
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"

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

class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry.git"
  url "https://github.com/google/s2geometry/archive/v0.9.0-2019.02.11.00.tar.gz"
  version "0.9.0-2019.02.11.00"
  sha256 "226315d1b720c12e9209c21f084f0570a069a02bea624886b69816291506edff"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl" => :build

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].include

    (buildpath/"gtest").install resource "gtest"
    (buildpath/"gtest/googletest").cd do
      system "cmake", "."
      system "make"
    end
    ENV["CXXFLAGS"] = "-I../gtest/googletest/include"

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "install"
    end
  end

  test do
    system "ninja", "test"
  end
end

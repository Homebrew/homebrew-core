class Vcpkg < Formula
  desc "C++ Library Manager for macOS, Linux and Windows"
  homepage "https://docs.microsoft.com/en-us/cpp/vcpkg"
  url "https://github.com/Microsoft/vcpkg.git"
  version "2018.11.23"

  bottle :unneeded

  depends_on "ninja"
  depends_on "cmake"
  depends_on "gcc"

  def install
  	ENV["CC"] = "/usr/local/bin/gcc-8"
  	ENV["CXX"] = "/usr/local/bin/g++-8"
    system "./bootstrap-vcpkg.sh", "-useSystemBinaries"
    bin.install "./vcpkg"
  end

  test do
    system "true"
  end
end

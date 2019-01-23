class Vcpkg < Formula
  desc "C++ Library Manager for macOS, Linux and Windows"
  homepage "https://docs.microsoft.com/en-us/cpp/vcpkg"
  url "https://github.com/Microsoft/vcpkg.git"
  version "2018.11.23"

  bottle :unneeded

  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
  	ENV.append "VCPKG_ALLOW_APPLE_CLANG", true
    system "./bootstrap-vcpkg.sh", "-useSystemBinaries"
    # bin.install "./vcpkg"
  end

  test do
    system "true"
  end
end

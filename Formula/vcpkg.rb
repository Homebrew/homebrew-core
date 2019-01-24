class Vcpkg < Formula
  desc "C++ Library Manager for macOS, Linux and Windows"
  homepage "https://docs.microsoft.com/en-us/cpp/vcpkg"
  url "https://github.com/Microsoft/vcpkg.git"
  version "2018.11.23"

  bottle :unneeded

  depends_on "cmake"
  depends_on "gcc"
  depends_on "ninja"

  def install
    ENV["CC"] = "/usr/local/bin/gcc-8"
    ENV["CXX"] = "/usr/local/bin/g++-8"
    system "./bootstrap-vcpkg.sh", "-useSystemBinaries"
    cp_r "#{buildpath}/.", prefix
    bin.install "./vcpkg"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/vcpkg version")
  end
end

class Skafos < Formula
  desc "Command-line tool for working with the Metis Machine platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256 "254500f6a5bd4bee3cbfc8a7d1c8ceec1595430d5b14a69d859f9de80b8ebd16"

  depends_on "cmake" => :build
  depends_on "libarchive"
  depends_on "yaml-cpp"

  def install
    system "make", "clean"
    system "make", "_create_version_h"
    system "make", "_env_for_prod"

    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/skafos", "--version"
    system "#{bin}/skafos", "--help"
  end
end

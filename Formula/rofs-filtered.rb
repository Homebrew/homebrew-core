class RofsFiltered < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"

  bottle do
    sha256 "74a12ef9a8b0767ca7803f274c78b004a3b5b1006bc8e30e1f3ea195a02cabfa" => :mojave
    sha256 "2662076d6c938fd260ee304e80999db5e22a1c516fdc5139c7e477892a5cc927" => :high_sierra
    sha256 "c6f0661d382c415db63caf4512b18b526e5e75c25a5fa54de792d4365db4dfa1" => :sierra
    sha256 "5c29bf0f477b23c3e3291549cffe632d3222899a34483cd8c23fe25f4d9b30ca" => :el_capitan
    sha256 "194e5e00804165b7df68037bce7d6bd6b3f64a244b1f48c04b16e346bd70832c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite
  depends_on :osxfuse

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
      system "make", "install"
    end
  end
end

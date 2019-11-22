class RofsFiltered < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "250c65163e46fc9eaaab11b27562c70775f2481cfe9f649ab151f8da3616ff08" => :catalina
    sha256 "6f220b4a193928a97dc8442cadf6d161224a1ddac098d496c8cf9a20fb7cd02a" => :mojave
    sha256 "74277c4f4cc2c60534cda38627450176f356da5bb7120334fd667eaa261fea7b" => :high_sierra
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

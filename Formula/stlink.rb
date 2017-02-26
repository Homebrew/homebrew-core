class Stlink < Formula
  desc "stm32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.3.1.tar.gz"
  sha256 "5d346b884b5cf1f7f9bb7fd7ee049b3b2e880785c7a15774d0b1a6574823e63b"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "5e196d94ffb88ce7734e77382f51508524ae50c10e46ff68d7c048c5be25f6dc" => :sierra
    sha256 "bdd4aa88ee679813d2ffa8abcdf6ee419b2455f99bcd08465c0a7b792dd33654" => :el_capitan
    sha256 "a5191388eec998a018aca64f0871a3dd0f374cd6ac41b5f56e993aa266eec8ee" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "gtk+3" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"st-util", "-h"
  end
end

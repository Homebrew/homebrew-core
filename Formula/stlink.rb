class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.4.0.tar.gz"
  sha256 "d99b8385cce8071d5e58de21b6c8866058af20a8dd46ecf01e1c1dc3aa038cc9"

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

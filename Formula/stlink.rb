class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.5.1.tar.gz"
  sha256 "e0145fbfd3e781f21baf12a0750b0933c445ee6338e36142836bf5a2c267e107"
  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "b888654aa9fedd067d92a2940ee8ec7f5240086db20c4af45679b4b8721e9b56" => :mojave
    sha256 "93f97f44122457654c9b4d47cfe2af0d9e2c73c040a18763486d06d4ee19d2e1" => :high_sierra
    sha256 "8c091af82164b5c930eb65f35a71a6dcf7a49144ecfc2fb96153fee31be6f54d" => :sierra
    sha256 "0109c086ee82894d942c5c1e9a0221ca6783bddcbdb0d810b68db59bc98306e6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"st-util", "-h"
  end
end

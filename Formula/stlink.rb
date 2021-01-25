class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.6.1.tar.gz"
  sha256 "ca9a640f84c3e2c9873bd51759594bc05c00cdf6e1f21b434ae2c0e7985433d8"
  license "BSD-3-Clause"
  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "28876d237d5ae87630ad88a78c5541687f78a97465c89cf3f9eac64afcc38dc6" => :big_sur
    sha256 "2318b55d4ebb80eac4b09f76ea89806b33d2662a00a5a7c5a942458a9fb97d5e" => :arm64_big_sur
    sha256 "e24c7913e29b627142d892c8dacfcbb077cea4a8abdb021d2b6624cd7ce61865" => :catalina
    sha256 "85fa59905d566f85a1f7b4dc86a2f770181550ac7402907c326b050f09053272" => :mojave
    sha256 "ca0da39790dc0a876555f19cbf227a05490c126a8f071e971118bdbbd2147787" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "st-flash #{version}", shell_output("#{bin}/st-flash --debug reset 2>&1", 255)
  end
end

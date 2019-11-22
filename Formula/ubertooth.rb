class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2018-12-R1/ubertooth-2018-12-R1.tar.xz"
  version "2018-12-R1"
  sha256 "0042daa79db0f4148a0255cdf05aa57006e23ac36edf7024e9e99ccc4892867b"
  head "https://github.com/greatscottgadgets/ubertooth.git"

  bottle do
    cellar :any
    sha256 "e08b1229ff32e200e5f6e7d562d83ce26e5dff0e50b4373f1add2a411854ebdf" => :catalina
    sha256 "9e6dcaeeff6974606332371fc0ce861d679bc9d00471f4185a7531b320e581fb" => :mojave
    sha256 "d3891c8cd1e395c8d7acd9f364d6d42d3bcb7d9d1ddd5adea9dfabc7f0aead69" => :high_sierra
    sha256 "b4e68f3183b67bd99d276c0889e6c36ea6a1c99931446bec237d9bf7b4cc5d81" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libbtbb"
  depends_on "libusb"

  def install
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Most ubertooth utilities require an ubertooth device present.
    system "#{bin}/ubertooth-rx", "-i", "/dev/null"
  end
end

class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2018-12-R1/ubertooth-2018-12-R1.tar.xz"
  version "2018-12-R1"
  sha256 "0042daa79db0f4148a0255cdf05aa57006e23ac36edf7024e9e99ccc4892867b"
  head "https://github.com/greatscottgadgets/ubertooth.git"

  bottle do
    cellar :any
    sha256 "7636cc62d42ca21c46725016dca62e3d7d866804d1a4b7a500eef9cbcafea540" => :mojave
    sha256 "f4cba66c8ce58e6e3044c566401591fa1374d8537162a131b39d974a9f8ae4e1" => :high_sierra
    sha256 "fe2308a7adbcd8fc7f8fafc1df12e6216a9077869cbdfa3027e8481018d09d6e" => :sierra
    sha256 "dcfe19e7ccbc1641673d09fd5409382a4b3eb5102f9bed6f2d52a0a98dd1efc8" => :el_capitan
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

class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2017-03-R2/ubertooth-2017-03-R2.tar.xz"
  version "2017-03-R2"
  sha256 "fbf83fc0129cb9a4e2df614b19fce8ea73419d1a01831142987d25148a9bcd00"
  head "https://github.com/greatscottgadgets/ubertooth.git"

  bottle do
    cellar :any
    sha256 "fac20ea8ff4542694b9981becf324613ffcf18017b0d9336543a17e218c2970a" => :sierra
    sha256 "48273e1db5b00160de2e06c4bf91316fd6e100547a2ef44b2e654c7f3b672422" => :el_capitan
    sha256 "5b88c567e8fd85a7bed6a064836a9ce09190c0df0f728c2577d5025d6b3ed1ee" => :yosemite
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

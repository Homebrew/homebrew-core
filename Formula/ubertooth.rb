class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2017-03-R2/ubertooth-2017-03-R2.tar.xz"
  version "2017-03-R2"
  sha256 "fbf83fc0129cb9a4e2df614b19fce8ea73419d1a01831142987d25148a9bcd00"
  head "https://github.com/greatscottgadgets/ubertooth.git"

  bottle do
    cellar :any
    sha256 "7b5472d02fcaf34434248c3630258c7b2eae64115247445186226e24b37ad207" => :sierra
    sha256 "95ba25253b67e36e263d7d9aca987caec686b313c6dc3e3b2d4bbf4bd4a12056" => :el_capitan
    sha256 "465f2ecfeacdd426609500d41bd0c3f5134e1885376a7aa2d99bafc3478b135e" => :yosemite
    sha256 "947fd37511e25e5e824ae9001f8e725e04cadc4f462349beb3a8e266f1ee98db" => :mavericks
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

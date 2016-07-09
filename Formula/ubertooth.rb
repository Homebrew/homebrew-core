class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2015-10-R1/ubertooth-2015-10-R1.tar.xz"
  version "2015-10-R1"
  sha256 "bc37e7978d137a64d918d7c8f1e7ca9cff093f9921d805e9809b12e5ab12ae35"

  bottle do
    cellar :any
    sha256 "95ba25253b67e36e263d7d9aca987caec686b313c6dc3e3b2d4bbf4bd4a12056" => :el_capitan
    sha256 "465f2ecfeacdd426609500d41bd0c3f5134e1885376a7aa2d99bafc3478b135e" => :yosemite
    sha256 "947fd37511e25e5e824ae9001f8e725e04cadc4f462349beb3a8e266f1ee98db" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libbtbb"
  depends_on "libusb"

  def install
    cd "host" do
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make", "install"
      end
    end
  end

  test do
    # Most ubertooth utilities require an ubertooth device present.
    system "#{bin}/ubertooth-rx", "-i", "/dev/null"
  end
end

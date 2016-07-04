class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https://github.com/greatscottgadgets/ubertooth/wiki"
  url "https://github.com/greatscottgadgets/ubertooth/releases/download/2015-10-R1/ubertooth-2015-10-R1.tar.xz"
  version "2015-10-R1"
  sha256 "bc37e7978d137a64d918d7c8f1e7ca9cff093f9921d805e9809b12e5ab12ae35"

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

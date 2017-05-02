class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.7.2.tar.gz"
  sha256 "bb6373dac49fbc621c478937b4255a01085bc9db3a5d1f8845e63a0468fe8cfc"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "6be050fb073c83cc138c7d68a2af5e39644972443ef8b4024eab187fb9b62f8a" => :sierra
    sha256 "69dac9a4d88663b606886ead521dc8822127db56c9e1295376126f99c6280836" => :el_capitan
    sha256 "cc64a5673faf87212d203921b2cfb847e168ebb3d5e33fab5d49a192bacab8a2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :osxfuse

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end

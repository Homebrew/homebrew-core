class Xhyve < Formula
  desc "Lightweight macOS virtualization solution based on FreeBSD's bhyve"
  homepage "https://github.com/mist64/xhyve"
  url "https://github.com/mist64/xhyve/archive/v0.2.0.tar.gz"
  sha256 "32c390529a73c8eb33dbc1aede7baab5100c314f726cac14627d2204ad9d3b3c"
  head "https://github.com/mist64/xhyve.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "babcee304193c68f484434c551732e5657878095f00c4149fc88867317f9252e" => :mojave
    sha256 "9643b72b869ec57653668f1ed2db0c3a2c7fad77d8000931933824622032d476" => :high_sierra
    sha256 "edc2e17147d4ae9333033e7317590a48b752b418df689a6dae45bd29a12eaca8" => :sierra
    sha256 "b0a94f72b09c71aa3bfbbf55669cd9e64ea309d6be8c838f6bc98aeaf8a6895c" => :el_capitan
    sha256 "e61ee4b3d2d3b5bba47f4288af54980f5de7991cadf6aa83dc058cb36854c789" => :yosemite
  end

  depends_on :macos => :yosemite

  def install
    args = []
    args << "GIT_VERSION=#{version}" if build.stable?
    system "make", *args
    bin.install "build/xhyve"
    pkgshare.install "test/"
    pkgshare.install "xhyverun.sh"
    man1.install "xhyve.1" if build.head?
  end

  test do
    system "#{bin}/xhyve", "-v"
  end
end

class Xhyve < Formula
  desc "Lightweight macOS virtualization solution based on FreeBSD's bhyve"
  homepage "https://github.com/machyve/xhyve"
  url "https://github.com/machyve/xhyve/archive/v0.2.0.tar.gz"
  sha256 "32c390529a73c8eb33dbc1aede7baab5100c314f726cac14627d2204ad9d3b3c"
  head "https://github.com/machyve/xhyve.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "b81d7e54464f0870eabe1fead9d31627ad5342fd2e9aaff47535a7bcc738751f"
    sha256 cellar: :any, mojave:      "babcee304193c68f484434c551732e5657878095f00c4149fc88867317f9252e"
    sha256 cellar: :any, high_sierra: "9643b72b869ec57653668f1ed2db0c3a2c7fad77d8000931933824622032d476"
    sha256 cellar: :any, sierra:      "edc2e17147d4ae9333033e7317590a48b752b418df689a6dae45bd29a12eaca8"
    sha256 cellar: :any, el_capitan:  "b0a94f72b09c71aa3bfbbf55669cd9e64ea309d6be8c838f6bc98aeaf8a6895c"
  end

  # Ref: https://github.com/machyve/xhyve/issues/207
  # Ref: https://github.com/machyve/xhyve/issues/227
  deprecate! date: "2022-11-04", because: :does_not_build

  depends_on arch: :x86_64
  depends_on :macos

  def install
    args = []
    args << "GIT_VERSION=#{version}" if build.stable?
    system "make", *args
    bin.install "build/xhyve"
    pkgshare.install "test/"
    pkgshare.install Dir["xhyverun*.sh"]
    man1.install "xhyve.1" if build.head?
  end

  test do
    system "#{bin}/xhyve", "-v"
  end
end

class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.01.tar.xz"
  sha256 "4a74f2a60b248dc7ff20e950facb4a7d010f46bf8c0cfcbed6fecf7c4daa8f3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff664c9da3f2c9e9576e35938f2c5e8796c80814f76dc0b864cc9ba29f78dbed" => :mojave
    sha256 "927350d621053e287f2001b7f3cd1a69bfa6fb0d5366e16cbb44ea1c485f891f" => :high_sierra
    sha256 "7b688aa6959a55ef8e0f34518bef70bf070f4696d8d44bca2d739f4b96b20dc2" => :sierra
  end

  depends_on :macos => :sierra

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end

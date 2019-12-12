class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.13.tar.xz"
  sha256 "da0442053de6db62517c49ad129a8a3f776f60e60591f3be05819eef512acb45"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b4ed30ef511ae912fbf7f5e43907bf7fa064604ee5e2da3ed7d68265222d1d" => :catalina
    sha256 "4f45108da1cd056c9340441db433a595fd4ce632a34670c8dfb68bae06053e47" => :mojave
    sha256 "fcd8788e53246cc9134bdd5a8bb90a63ac2cf26fedb57fa1b355ec1814b896e8" => :high_sierra
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

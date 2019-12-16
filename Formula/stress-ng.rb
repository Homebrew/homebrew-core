class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.13.tar.xz"
  sha256 "da0442053de6db62517c49ad129a8a3f776f60e60591f3be05819eef512acb45"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a62d0693eabcdfdcafc23a483aead1496cdd774726a3a78c167bfbff1ac5697" => :catalina
    sha256 "b10cf7ec7a41013e59787bbe1d1a29aad22a3cd7f04a86ab38fe28d56327b2e3" => :mojave
    sha256 "40d618af55b915384eea0e3f8a6d6a89775fca2b5306dc76af18636d2e34deef" => :high_sierra
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

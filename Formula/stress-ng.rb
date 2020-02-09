class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.18.tar.xz"
  sha256 "f069eb8e324de1c2341262e23f1ab55791de8a723dc6456ee113f0fbb71ea753"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb994c5fd61a8f3baf8593837175bc3a50ad6efa2c911a10bb8e4e972430e41f" => :catalina
    sha256 "ae3f0df1a87646e257cd718aaabc89e94ea24b09c2c7ccf6fe776c311d88cc8f" => :mojave
    sha256 "b2cb3fa18d8b9e991201607fc7cfc21aa890a49e211a36282c5be4cd5f68c31f" => :high_sierra
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

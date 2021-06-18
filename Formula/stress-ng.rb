class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.10.tar.xz"
  sha256 "bd167b6559fa8a28680371b1defd3ffe2344eb550129d58dd7d5e2d568f2786e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c03482ccc0e7b5ab0ad153053edbce458226b30220efa40e2526685056ecda2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "262f4a7c5b8c4255e63b627aba2861c2b0462e8f63e837321543c9186013b359"
    sha256 cellar: :any_skip_relocation, catalina:      "ea2108288b71f60a99f6ba14f2ae129d0421aa6be44e33423ab6726475722f01"
    sha256 cellar: :any_skip_relocation, mojave:        "bbc9061c112feac0a0ab503bb89bcea2a31bf0298586825f99e0661a9e9ad29a"
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

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

class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.13.03.tar.xz"
  sha256 "3e60d605e378d86a8591a30d6e557bed709d82a5b19616378002cd8ff0037a8b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7949a705b3f659361e1cabf037c03abd59835ff94e08dc330b6bed38c2ee4fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c984db6b9b6012cf68d5fd6bf745349a9358bdcacfbf84303f5131bb59856d8"
    sha256 cellar: :any_skip_relocation, catalina:      "c6f78292f42eb8295f3c05479013247282da1ebfe89c140b870ceca5f7ec2e7f"
    sha256 cellar: :any_skip_relocation, mojave:        "acb20ab59f3593380048764488d69f4466deaab1154d0954066ddfa71dc69b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c73086eca79e6acb0983998fdce4154c074c84b9921593a4b7dbe568245c28"
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

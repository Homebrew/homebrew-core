class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.05.tar.xz"
  sha256 "af7779aee38e6d94726ed7d5cf36384a64d50c86e42fff89c141d8609913f425"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "775a06636f87bddec13a9f9087f06f9101471b83cbc790c32f2a8ed9a66b4cb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "39ae192e369429334afa8f0c02dfa03772fb23faf20e0393a01837737a77cf03"
    sha256 cellar: :any_skip_relocation, catalina:      "20387bff63d8101226300fc1340d74368ef96c06e701d27e8bb68c7f860c8569"
    sha256 cellar: :any_skip_relocation, mojave:        "40beabf64462c7a7460c7fc6e9d08ed55e454c8425d477bfd7ca39fe602ca619"
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

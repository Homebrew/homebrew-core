class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.04.tar.xz"
  sha256 "b4e34bda8db4ed37e33b7a861bc06ad77cbbd234d63236da2cb58f02e3f3218e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90dac59cc3dfbc152d1a5675516cd203a6f4880bce6b6f9845c7517c40ebad7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "156f0a1c26682d165b3a7aa88cda897b64c09a8fd835d11b72a24489fd6f02c2"
    sha256 cellar: :any_skip_relocation, catalina:      "4f6509865a461e5ff109cfa0d7d559a5d7e7b25bbf7221639011ffba2597455c"
    sha256 cellar: :any_skip_relocation, mojave:        "6419703d9504d1132c69276091df78a05d660fff4c843a4a904eebf4ede8b208"
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

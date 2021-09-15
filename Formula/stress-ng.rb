class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.13.02.tar.xz"
  sha256 "e917ef2d0179ac5e3887e3386f1edad44aa08cd61ef34ffae7c456f2a4e6bf1a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4168b513208685b2e0eb135220f2f3a31b489a88efbaf0cefa0cd4d5683101be"
    sha256 cellar: :any_skip_relocation, big_sur:       "d14000701cf6767437a53a634aef948d9d73d8c0e017e108f37ab66ab76b7472"
    sha256 cellar: :any_skip_relocation, catalina:      "0da623389096d0709627a43694f869674faa38c20907ee3f97516e414de5ed34"
    sha256 cellar: :any_skip_relocation, mojave:        "0978a2dd208973f582e5d04b3d83573acf965505639fd060406148f581020fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4644af62dec374bfcabcb1c4bc2f0fd2d312fdbf297f57cd23a83a1ac8990f9"
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

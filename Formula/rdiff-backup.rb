class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.5/rdiff-backup-2.0.5.tar.gz"
  sha256 "2bb7837b4a9712b6efaebfa7da8ed6348ffcb02fcecff0e19d8fff732e933b87"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8ca9789a8e2456096ab851fe8277004201bc2f9ca66adf6934a6a942f9eaf3d3"
    sha256 cellar: :any, big_sur:       "da5cbef995206de251e217fbfb1a0594d3222c26c20c003df78a8aad6e855b8f"
    sha256 cellar: :any, catalina:      "1597986cbff907a671f1449f59b0f456344e27b9104f7139d40f001b67d27477"
    sha256 cellar: :any, mojave:        "875e5fcc8ae219dc64d5c2f3e435313f69fd4d0ea595d01ff3ae70fe5873b547"
    sha256 cellar: :any, high_sierra:   "215f96cb06d3e4c64dd52081fb22cfa6658ab25bd3fd76b52a128c70b5c93838"
  end

  depends_on "librsync"
  depends_on "python@3.9"

  def install
    system "python3", "setup.py", "build", "--librsync-dir=#{prefix}"
    libexec.install Dir["build/lib.macosx*/rdiff_backup"]
    libexec.install Dir["build/scripts-*/*"]
    man1.install Dir["docs/*.1"]
    bin.install_symlink Dir["#{libexec}/rdiff-backup*"]
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end

class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.5/rdiff-backup-2.0.5.tar.gz"
  sha256 "2bb7837b4a9712b6efaebfa7da8ed6348ffcb02fcecff0e19d8fff732e933b87"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "da5cbef995206de251e217fbfb1a0594d3222c26c20c003df78a8aad6e855b8f" => :big_sur
    sha256 "1597986cbff907a671f1449f59b0f456344e27b9104f7139d40f001b67d27477" => :catalina
    sha256 "875e5fcc8ae219dc64d5c2f3e435313f69fd4d0ea595d01ff3ae70fe5873b547" => :mojave
    sha256 "215f96cb06d3e4c64dd52081fb22cfa6658ab25bd3fd76b52a128c70b5c93838" => :high_sierra
  end

  depends_on "librsync"
  depends_on "python@3.9"

  def install
    ENV["ARCHFLAGS"] = "-arch x86_64"
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

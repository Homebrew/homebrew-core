class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.5/rdiff-backup-2.0.5.tar.gz"
  sha256 "2bb7837b4a9712b6efaebfa7da8ed6348ffcb02fcecff0e19d8fff732e933b87"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "4ceb0c2146ca9ad88e9d05dd27b294568127a2b97695368045789428a82ab4b3" => :catalina
    sha256 "c761dd827e1cba2dfe9b946768af39034a8d844e8014bfcedd4729412d22861d" => :mojave
    sha256 "62f0c516b83e424aac3bea2a31fd624d27543e070363d238a02e2b9ebae40dae" => :high_sierra
  end

  depends_on "librsync"
  depends_on "python@3.8"

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

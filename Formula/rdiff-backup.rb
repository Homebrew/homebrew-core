class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.3/rdiff-backup-2.0.3.tar.gz"
  sha256 "04e2d2c28588d6bb4abb0b7dc7c922e5974f3cb3e7f0671ecc5a90b438dfd5e1"

  bottle do
    cellar :any
    sha256 "e6a3e3f38d6a9e87f10f92bcaeb8d2fcbe09826de82bac82a464848a8930cb60" => :catalina
    sha256 "7be7e61ddb4176234d72473d11178a9d96d16f82abe10f9e9936966c05af60a2" => :mojave
    sha256 "3074d321311ca9f8b8a001eaf0c92941aa1293630337116f4039d3188a1bea98" => :high_sierra
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

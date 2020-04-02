class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.0/rdiff-backup-2.0.0.tar.gz"
  sha256 "5b0e7afec624862c01acb5470da0519d8945af12819a4303a13ba82b654d8ee8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "935ffcd8c7ba9579aaf0c640c30ff6b877ae862e5ca5083619c51200ab6847cc" => :catalina
    sha256 "76ac2c10776a2dcb230f07b95704c65522cae20865a9bf4e4772c86b94673bda" => :mojave
    sha256 "899687c88770af610d76f66f02da736a2a62ac4676f0f80796dbbae1d92bc47f" => :high_sierra
    sha256 "7dcf4c878ccafc113e5742c83214f946dd3a55b472e086a944e918bcee1cf2bd" => :sierra
    sha256 "f06f79bc1536dbaa990e6005565f18de05e9dc12deb09701a504ab6bfc8b8f11" => :el_capitan
    sha256 "35f6a0f726a680d639f7a1c83af8e27d046d5a68a334bf19d47eaa363748767c" => :yosemite
    sha256 "5b0eab2335afe2d298cd51737c744d052536cb0bdbee780819496e1000a3b179" => :mavericks
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

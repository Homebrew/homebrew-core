class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.5/rdiff-backup-2.0.5.tar.gz"
  sha256 "2bb7837b4a9712b6efaebfa7da8ed6348ffcb02fcecff0e19d8fff732e933b87"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "9841037fad91c2e5567e03916d7413fd1e74d6858dff760b2a3728c53e1baf80"
    sha256 cellar: :any, arm64_big_sur:  "66247de6c20d7350372ecb4efb63b3f5bec4c7f2fe29c4ed80723ebdcd0018fa"
    sha256 cellar: :any, monterey:       "c64863e034cc7deb4de5574243baac6b0c180ab556ccea2b8fde137cd1910d74"
    sha256 cellar: :any, big_sur:        "3aaeb0620c7dd027efea476c6b3af79425a7baf2056abc29ed88e405bf2f107a"
    sha256 cellar: :any, catalina:       "e53a41d9556104c8b72a6b876969b2634d48a1153552af42af86456b5c1add67"
    sha256 cellar: :any, mojave:         "f3d24f92212373f45e8323a8d054cef1b1ee0b392c96034cbf461bb60b0effd6"
  end

  depends_on "librsync"
  depends_on "python@3.10"

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

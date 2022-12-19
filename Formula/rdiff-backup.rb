class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/cd/04/f0b845259e91da83a24d32656974616ac0001d57ed6039e720babb6c5faa/rdiff-backup-2.2.2.tar.gz"
  sha256 "4ce1ddd8ab15f4faed8cf547397b77ef10405c084bd61cb2a999f0ed1f78c1b9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00738ee63bb98459076c6dc2673e28d7945129eb17f6cfb31a8f751ea6b94b6f"
    sha256 cellar: :any,                 arm64_monterey: "9841037fad91c2e5567e03916d7413fd1e74d6858dff760b2a3728c53e1baf80"
    sha256 cellar: :any,                 arm64_big_sur:  "66247de6c20d7350372ecb4efb63b3f5bec4c7f2fe29c4ed80723ebdcd0018fa"
    sha256 cellar: :any,                 ventura:        "257e6838c0ea2cc6cb32c0650f4a950c2c55c8fcee8718c844c55edc985aa999"
    sha256 cellar: :any,                 monterey:       "c64863e034cc7deb4de5574243baac6b0c180ab556ccea2b8fde137cd1910d74"
    sha256 cellar: :any,                 big_sur:        "3aaeb0620c7dd027efea476c6b3af79425a7baf2056abc29ed88e405bf2f107a"
    sha256 cellar: :any,                 catalina:       "e53a41d9556104c8b72a6b876969b2634d48a1153552af42af86456b5c1add67"
    sha256 cellar: :any,                 mojave:         "f3d24f92212373f45e8323a8d054cef1b1ee0b392c96034cbf461bb60b0effd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dedf7b7d0f5341a6159e46485c358502f3e50682db4f33f6ac69877830d0c99e"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, *Language::Python.setup_install_args(prefix, python3), "--install-data=#{prefix}"
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end

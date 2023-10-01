class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1a6059b860c19580ee73dd95380bd38f94d6b400bb172bab07b42da6650307f"
    sha256 cellar: :any,                 arm64_monterey: "985a81f2183cac7d2a8d016d9c990f61801b320f27df21c0eb5a3f068068434a"
    sha256 cellar: :any,                 arm64_big_sur:  "42cb546126b06033e25040430acd50360b623ce474fc3b35fca697b91294c415"
    sha256 cellar: :any,                 ventura:        "d43a0aca5449acf0abf915b4cfae232329999fd49d0ed4a15d9cf58b9972591f"
    sha256 cellar: :any,                 monterey:       "172de9fcd3da2877e2b0718647d30f3df5f64a13c2327c235b6db289ba9de5bc"
    sha256 cellar: :any,                 big_sur:        "a9406a53d7ac5fe450d34c9b75c6cf974de62268b96c1cf2f8d4cc975848dbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaae5a0df1be561eafe424de6ba531a0a6d044f82789caecacc33ae125602643"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end

class RdiffBackup < Formula
  include Language::Python::Virtualenv

  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "62fd587d8c28af3c9d77efb118598de7c403bbb2c009b09460e8b9bddd79a70d"
    sha256 cellar: :any,                 arm64_ventura:  "be41d5549775c6739fed4c65fcc7fa752e73b3fe63dfbebf3efbfff85ba04146"
    sha256 cellar: :any,                 arm64_monterey: "d2dacadf8f82a72150eae57c64d25524fa955621c625a558d93355545a4bbfd1"
    sha256 cellar: :any,                 sonoma:         "bb40dc033e4d8992cfa59505076e02abd3d402f23f7208a9bb5570e030ef13bd"
    sha256 cellar: :any,                 ventura:        "0770ec28406a904435d3b1b6a930dd166825e2525463a2eaa4a5007ba6adbaa3"
    sha256 cellar: :any,                 monterey:       "c84f174a0733cb509939b690c7e53330ac9964c745c7462dd78d9a66dfbf455f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc6afbc870dc89ba65d8384947391fbff6781ee4bd9a174f2987463dd2ddf12"
  end

  depends_on "librsync"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"rdiff-backup", "--version"
  end
end

class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 6
    sha256 cellar: :any,                 arm64_sonoma:   "7922f887ef1f2c23b843435951889a33145c859b8056eda662eec00d04d8b5d3"
    sha256 cellar: :any,                 arm64_ventura:  "769ab15671e835ba1756c30c3ea76032a5c52ba1927bf9fdde439e7082075d61"
    sha256 cellar: :any,                 arm64_monterey: "1b66153ebd94f85ee560cdf236a8d26ecef1e620a8efd98ca63281a141a5ee15"
    sha256 cellar: :any,                 sonoma:         "b8e11ff3fa7bf119727cea4cdcc6ebf2ba981f8997c99b2d270f2ebd611c248d"
    sha256 cellar: :any,                 ventura:        "62e6e995e43df7c081980a7c31023c159433abb3e986a97e401f93f6756c884d"
    sha256 cellar: :any,                 monterey:       "daca75dc6b4cf283f8e435fdcea2370928a329ec75d12fd6cf9b0777e3ad927e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "122789a1d359511eef13ffcb1b0c377659e9dc601c194fab1efbdefa20a6fa90"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  # Drop unneeded argparse requirement: https://github.com/miracle2k/tarsnapper/pull/72
  patch do
    url "https://github.com/miracle2k/tarsnapper/commit/def72ae8499b38ab4726d826d7363490de6564fb.patch?full_index=1"
    sha256 "927ff17243b2e751afc7034b059365ca0373db74dcc8d917b8489058a66b2d1c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end

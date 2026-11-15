class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 9
    sha256 cellar: :any, arm64_golden_gate: "afd50b26f881005c7475550bd820f07b7315c0d0c280907ed3cd245e1a903901"
    sha256 cellar: :any, arm64_tahoe:       "4132ddba92421d31c3174aa898460bbe51de1d10451e91e41864e19083d57059"
    sha256 cellar: :any, arm64_sequoia:     "0dcdd36e1f1344a967c926b8ad6ae4a8ae4333654e6fba074210be075297da86"
    sha256 cellar: :any, arm64_linux:       "3f4f36f42f67ce294df75efc95dd48114027e4f59d4062785b8a3310648e6d35"
    sha256 cellar: :any, x86_64_linux:      "1598ef348e2e2cf74619d6b44d7f4bcd8f74c2d5e812ce666e3993421cd7d428"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  # Drop unneeded argparse requirement
  patch do
    url "https://github.com/miracle2k/tarsnapper/commit/def72ae8499b38ab4726d826d7363490de6564fb.patch?full_index=1"
    sha256 "927ff17243b2e751afc7034b059365ca0373db74dcc8d917b8489058a66b2d1c"
    type :unofficial
    resolves "https://github.com/miracle2k/tarsnapper/pull/72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end

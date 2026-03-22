class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 8
    sha256 cellar: :any,                 arm64_tahoe:   "32c13f98b225238a1c36beb4aea44cc7aa9fc5f0ea6916836e9f24c9009a759a"
    sha256 cellar: :any,                 arm64_sequoia: "aede490b7d29991225df23efd94e0c740fc0a179b2625a54e026865ac4916f78"
    sha256 cellar: :any,                 arm64_sonoma:  "4a553095ec22748abec5bdab416bd67fc74865d373b20d36befb36afe40ba08f"
    sha256 cellar: :any,                 sonoma:        "4368cf715ad3a98e93ae54bcd6df1532199927753a4bb5915155141a183ea5a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a08f2b3ac06f061600d9a402ac6ffca74de70f9e973699fbf14e9f3dfaa7a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba5eacaf4328d52c8277a96a4befdcac0570cb99372882717562683797c677c5"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
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

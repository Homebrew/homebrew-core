class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/32/d1/2728789232c766247375f98cb9d224f1db4070c5ed836468dc8c7c1359e8/showcert-0.4.16.tar.gz"
  sha256 "ae4ccd86b2fc6c5e4701be4c2b08b499966de1312bccbc58496fec69f1e1fcfc"
  license "MIT"
  revision 2
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5e78ff3be637a7848faf8ec737758d011b6b148c872c84f4d84602875c43ffe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5e78ff3be637a7848faf8ec737758d011b6b148c872c84f4d84602875c43ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5e78ff3be637a7848faf8ec737758d011b6b148c872c84f4d84602875c43ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "077390664e84bf144caa4a58c036ae7c7af1ed0a5d1729e89e57f3673cd73084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "077390664e84bf144caa4a58c036ae7c7af1ed0a5d1729e89e57f3673cd73084"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showcert -h")

    assert_match "O=Let's Encrypt", shell_output("#{bin}/showcert brew.sh")

    assert_match version.to_s, shell_output("#{bin}/gencert -h")

    system bin/"gencert", "--ca", "Homebrew"
    assert_path_exists testpath/"Homebrew.key"
    assert_path_exists testpath/"Homebrew.pem"
  end
end

class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/32/d1/2728789232c766247375f98cb9d224f1db4070c5ed836468dc8c7c1359e8/showcert-0.4.16.tar.gz"
  sha256 "ae4ccd86b2fc6c5e4701be4c2b08b499966de1312bccbc58496fec69f1e1fcfc"
  license "MIT"
  revision 1
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bf593201512f8c1783c9f15b6219e067e3044d3939c306af77ff742b6fb63d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bf593201512f8c1783c9f15b6219e067e3044d3939c306af77ff742b6fb63d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bf593201512f8c1783c9f15b6219e067e3044d3939c306af77ff742b6fb63d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "877bdc676f26bdaafce37aa0d6952d89312b2cd84178af6fe4f0c1110507691b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260fabaa9d1ae27b5283b9f799c3df7d605480265d0e4ff728765e775562932a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260fabaa9d1ae27b5283b9f799c3df7d605480265d0e4ff728765e775562932a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/8e/11/a62e1d33b373da2b2c2cd9eb508147871c80f12b1cacde3c5d314922afdd/pyopenssl-26.0.0.tar.gz"
    sha256 "f293934e52936f2e3413b89c6ce36df66a0b34ae1ea3a053b8c5020ff2f513fc"
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

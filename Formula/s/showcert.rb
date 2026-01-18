class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/32/83/403cd1359af5f7a3525dfdd7e4c0d7a98d79c7d307cc8c5c44f389f2125e/showcert-0.4.12.tar.gz"
  sha256 "c2f259e683baed02399023d1f68442aebf46f7330aa5d76fab6f2766d6d8a7dc"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd66e46cab283b7f155ba949b4bccef0259c60876602477294347ee93caf5800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd66e46cab283b7f155ba949b4bccef0259c60876602477294347ee93caf5800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd66e46cab283b7f155ba949b4bccef0259c60876602477294347ee93caf5800"
    sha256 cellar: :any_skip_relocation, sonoma:        "82f5ce738b97781e19d03b153dcc43850358ff22c2f331b29e0433e3d85b8106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59f2e021cbf545fc538b2b2b206dc72394e947ee99e08d3eb2951ffe787ab88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f2e021cbf545fc538b2b2b206dc72394e947ee99e08d3eb2951ffe787ab88b"
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
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
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

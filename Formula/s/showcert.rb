class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/3e/4e/848aeb332a64ff400210e80f6e7cb86340aa88142300885b3d8f58b9da8f/showcert-0.4.7.tar.gz"
  sha256 "42e2ccb1349c81dcb6f6c67e16cc37c58ffe6af6ff18f72df9414277e3f8ba4b"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7db65d5003888d91d5882209b1cd9b0bf6dee69b8e125454c56ffbfc766c2ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7db65d5003888d91d5882209b1cd9b0bf6dee69b8e125454c56ffbfc766c2ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7db65d5003888d91d5882209b1cd9b0bf6dee69b8e125454c56ffbfc766c2ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7db65d5003888d91d5882209b1cd9b0bf6dee69b8e125454c56ffbfc766c2ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aad6faee5150e4a343d9ca196f1b25970053c7938d80b897a86df9e23f206b9"
    sha256 cellar: :any_skip_relocation, ventura:       "6aad6faee5150e4a343d9ca196f1b25970053c7938d80b897a86df9e23f206b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2643a5f9d6dd150b412ac9f2135c12f04bb49013e5d03d0e7c4707db8cdcfa82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2643a5f9d6dd150b412ac9f2135c12f04bb49013e5d03d0e7c4707db8cdcfa82"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
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

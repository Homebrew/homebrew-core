class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/98/46/23b8cffc150fbcaea1da3335a73fb2e12e888350ce9681abf8bb76dd1f7e/showcert-0.2.12.tar.gz"
  sha256 "4f9f29f7385033fef3c0e12b84869cb19bd126fea8c50904e6259b5b025e481b"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "646e754e0ea20a5c48b2108f3d823e248515d9689df4723ca97df9e543cff3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646e754e0ea20a5c48b2108f3d823e248515d9689df4723ca97df9e543cff3b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "646e754e0ea20a5c48b2108f3d823e248515d9689df4723ca97df9e543cff3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "784a87ade8d3f7dc454b9b8784ffdb1421cde96cd0e703aebe77d1c86d96652e"
    sha256 cellar: :any_skip_relocation, ventura:       "784a87ade8d3f7dc454b9b8784ffdb1421cde96cd0e703aebe77d1c86d96652e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646e754e0ea20a5c48b2108f3d823e248515d9689df4723ca97df9e543cff3b5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
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

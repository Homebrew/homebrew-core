class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/57/f0/e97753c41d07f90a3df653fe885c0ede54734e232728365e068573aaaa9b/ruff_lsp-0.0.40.tar.gz"
  sha256 "15e7b4a500a11cca34040348a689830ea5739dc2edb0ad51a05deec293bfacf7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c1c973ccb6f87f76701e708a640756eb0307ee84f23904d434abc333426be00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c451af62399969ddc7d2fd4b214d3a626cdba80f6af0b58d008b3fb64ad39fbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8efb540deac738c7d898233a1a2d8191dfc1b910a53a4884d9be1f738946116d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2e70db033ee237fdf2cab67438ac18d4c6a673d2889f0ca763e9cfb620232e6"
    sha256 cellar: :any_skip_relocation, ventura:        "40c2f0925c69c172b9c5ba66446bc722dad9da900a7125bdd0c5f828544966b7"
    sha256 cellar: :any_skip_relocation, monterey:       "4ad0995755858c3417e511ac09b83407bd26debaff8632cb1953717333c2bf21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4bafed1d3e971b0ceabc6577b6702fee9313de7b2471cf1089623e8ed1fb0f"
  end

  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/22/a1/4df53bbe3663de65ad90c6bbc2e6e8779b61fba1e13ee9a21a0f2f7db8f9/lsprotocol-2023.0.0b1.tar.gz"
    sha256 "f7a2d4655cbd5639f373ddd1789807450c543341fa0a32b064ad30dbb9f510d4"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/10/1a/4994d487a7295a7c834a81003b83b00b26086dbd3747699ed3eb20e73fcc/pygls-1.1.0.tar.gz"
    sha256 "eb19b818039d3d705ec8adbcdf5809a93af925f30cd7a3f3b7573479079ba00e"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/af/40/3398497c6e6951c92abaf933492d6633e7ac4df0bfc9d81f304b3f977f15/typeguard-3.0.2.tar.gz"
    sha256 "fee5297fdb28f8e9efcb8142b5ee219e02375509cd77ea9d270b5af826358d5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruff-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end

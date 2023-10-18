class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/0a/f5/ece4de09458e38d81e124936fecd74ca8b97f6ef02eaccac4fa39e56df86/ruff_lsp-0.0.41.tar.gz"
  sha256 "76d235279e067995971ddfc840fa4950d479adb793cb511fc5a75c362beec0d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b5282d9a08e529a5fa3b053800a2181236ab58602029efa35139327ab86cfff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a37c5dc84cffc8592737cf44e3c93eec2479655f3cf05d477779931121aa73b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58aa939a9c075a45d4d10cb888c03f98f5c5d8fdee4b93c580ecf4a239c40a85"
    sha256 cellar: :any_skip_relocation, sonoma:         "16787a8f74a1f2f9a3610a5a7de28de5005aee0e98154bffbf3db8391a7c2f61"
    sha256 cellar: :any_skip_relocation, ventura:        "7d3412c0e79faeaa527cf867e8305fb0f716319e1ddd1bc656f5928d0dcc9111"
    sha256 cellar: :any_skip_relocation, monterey:       "5ea1909d178f5a649a8a718b610e585b4199f9cfde35c5f44dc204b0f6952f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e730763b27531c6ebce3a9cbe566b879cc9e50114aa94767378fd6fae1e8934c"
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
    url "https://files.pythonhosted.org/packages/b2/02/cedb2febde8ff53ec21d299159027dc8a9423118f2d3ab7151441a79e972/pygls-1.1.1.tar.gz"
    sha256 "b1b4ddd6f800a5573f61f0ec2cd3bc7a859d171f48142b46e1de35a1357c00fe"
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

class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://github.com/astral-sh/ruff-lsp/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "3210d27a5c169050638d38db742d063db94786e2e0a89389e1f1e953091e649a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "661cb5f59fbf3068cd038d8fadd82f8653939a9f4f404e123368f4b0946797af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47043ef1c87d67d8299eafd1546dd2fb7e7e9122b4af91b8b096e4e2cf49bf2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "660614e84b9d36cd33c05037da38bec8a70715ac0385eafa677b2596c6b95ff5"
    sha256 cellar: :any_skip_relocation, ventura:        "4dcff1790da77511cfac3f251163427598d0d4640272b906a1d3ee870138181d"
    sha256 cellar: :any_skip_relocation, monterey:       "e28c20980c51fdf2235e7d4701c72c0f02fd3ad3d1e5a9dd17f3652758ec5e50"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0497199ce6233334dcf674a971d26604fe7f0e8af3172e8e7fb5c32205d385a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8e4f1a9ea1769c8da348d1bddc55076656633067f39f4ae7fbf364d81cc7e8"
  end

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
    url "https://files.pythonhosted.org/packages/f3/70/4e0e841e35ac450ca7f994020887c05aeb4d0cd25e8d53901f448dd43acb/lsprotocol-2023.0.0a2.tar.gz"
    sha256 "80aae7e39171b49025876a524937c10be2eb986f4be700ca22ee7d186b8488aa"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/bb/c4/fc9c817ba0f1ad0fdbe1686bc8211a0dc2390ab11cf7780e9eeed718594b/pygls-1.0.2.tar.gz"
    sha256 "888ed63d1f650b4fc64d603d73d37545386ec533c0caac921aed80f80ea946a4"
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

class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/d8/e8/de30cd65be061390ebbaeea20cec415d76bfd55d2a9c94af0c036e4438af/ruff_lsp-0.0.37.tar.gz"
  sha256 "15def4d654157c91ba05db0a57e027dc7c092b93ea8e2725bc81a1747631f4cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd648d5a255eede70e3d3e5b3b36b31db313750f92ef03b5a7e98b3ef9053686"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a129b07d5ed7d0e47ed32f9d0647b937296e75a2a7d5239abd93765aa608cd60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "985aab9a2b37fff6a3837dae9a50ed7cbd907bec6ccf4afbf41efbab0ca91986"
    sha256 cellar: :any_skip_relocation, ventura:        "815a5e1736c1b0851df12a7211ce98acd5a1d29c613c3961bb4ec1f27647688a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a653cb39106c355b0c900a814d1f74236471482c6e7dab08937bf2f2052fe2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "edece0f482e4ae865baaa4c573eed5c5fe45e64a9448d324391a43b0fbf4c1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ec683833df6e16f168e627454a39b7af6be2fb33a8d71db340a79f9082742a"
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

class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/46/ca/0db95d99efa6610fa2c582c8938dff1d8cdd8cdcd95480c83644639cc9ad/ruff_lsp-0.0.39.tar.gz"
  sha256 "faab8b836040df6ded8b1e3eca11a11ab7b7108b14e2f5d5deff8cc131676881"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc8c5627a6f33240c38feadfc0f4026f8664df730b2f6d8b9fe649afa02e3ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c17956893524120c3c96a56477bbdfc4fc7c6207c114489d1f8b26ebe426fd09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fd1cc0963223c61dab983dacaf1bb8902cdec6217fe657f542e9702832445a0"
    sha256 cellar: :any_skip_relocation, ventura:        "eb695f0022471e29b72696c734a34059d61bc2e8d1113f01838f3435e30763a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1e2cbeeb04c590be5cfdf81d55dc75929f687a688dbe4ec53d049b87f0a664"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0f99f778460c815d2b96f4a49348cedd993d007b3a05c715075f64714f265c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1afb02d215293725b2addc5c7994947457e3120147265582008303ee4aac42"
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
    url "https://files.pythonhosted.org/packages/1c/a3/146d67e3433bacda203206284fdb420468b89dfd8afc5a710a73bc6a5ace/lsprotocol-2023.0.0a3.tar.gz"
    sha256 "d704e4e00419f74bece9795de4b34d02aa555fc0131fec49f59ac9eb46816e51"
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

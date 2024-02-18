class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/8a/82/73fcdc5b374839ca50bb10e98f9f6b05f4a42ac398250825165b93c833ee/ruff_lsp-0.0.52.tar.gz"
  sha256 "3861c8fb81db005d51c0c15939fae05a6488182847bad936e1cc95bad519d107"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50fdb8dda0e9b518f71756d54341c506245747e668aad75bdb2987a4c0f7a86d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c8a0ea78396d8b7a9e4eef8d74b010562a15c5e0085ba126d49ffbb09fb91a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8208f32992211f4dc0f70597d82649bc6623a5e02e8a022812aaa1f18ab257f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e99ac0774722b1b9d0ba95f4de10c0bb19d468278a2f8b3bca4933a367a13026"
    sha256 cellar: :any_skip_relocation, ventura:        "fc6b63185031b7877d6491e09c3198912619e9685283da7e0e94b8ce7059a693"
    sha256 cellar: :any_skip_relocation, monterey:       "85152e6c9a07ae871c469de2ad7ccad868e9f6eeec6c7d8352300ffd56336117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2444309d1bad8bac62f529bc871d4d8c99a12284a91a393e32d5125e1479fafa"
  end

  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/e9/8d/31b50ac0879464049d744a1ddf00dc6474433eb55d40fa0c8e8510591ad2/pygls-1.3.0.tar.gz"
    sha256 "1b44ace89c9382437a717534f490eadc6fda7c0c6c16ac1eaaf5568e345e4fb8"
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

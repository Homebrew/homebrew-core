class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/a3/a2/8e165ce9edb98771f86b85a147f2e5ab268e8a578aa71c753572ad035b0b/ruff_lsp-0.0.55.tar.gz"
  sha256 "33fcfc77bbdc47f7a116a64f5fb9140e70d76d54f55a0d9a740a21b797906a45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c8b4589c86fd49520ff93396f557b2cafea9c9914125b73857ce0e8469f7181"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c8b4589c86fd49520ff93396f557b2cafea9c9914125b73857ce0e8469f7181"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c8b4589c86fd49520ff93396f557b2cafea9c9914125b73857ce0e8469f7181"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c8b4589c86fd49520ff93396f557b2cafea9c9914125b73857ce0e8469f7181"
    sha256 cellar: :any_skip_relocation, ventura:        "8c8b4589c86fd49520ff93396f557b2cafea9c9914125b73857ce0e8469f7181"
    sha256 cellar: :any_skip_relocation, monterey:       "8c8b4589c86fd49520ff93396f557b2cafea9c9914125b73857ce0e8469f7181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a8735ec52f84a69127c7bd2345cf46f08b26875df2bbb5222f4bbc9bbb6102"
  end

  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/86/b9/41d173dad9eaa9db9c785a85671fc3d68961f08d67706dc2e79011e10b5c/pygls-1.3.1.tar.gz"
    sha256 "140edceefa0da0e9b3c533547c892a42a7d2fd9217ae848c330c53d266a55018"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
    output = pipe_output(bin/"ruff-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end

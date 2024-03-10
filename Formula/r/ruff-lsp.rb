class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/4e/18/04110904e240a2bb1a95f3f63b49374961d752b30e3f6726b4d6fa6aa9fc/ruff_lsp-0.0.53.tar.gz"
  sha256 "de38eccd06020350630ac3518fe04a9640c8f66908758d8a623b5ea021bf84b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f449666b39ddcde467f0b4ab1dece92a5e0b18388dc606eeb4584a22516aa640"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "606f898606de4ccb3fa1cb97d433f3f5c5c086b47264e66964f22b8b1bee07c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e47e4cff6339d99a04f0e0c899f3fda084d7edf90949c6ea433cf4d56703aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2650c1cb1bce3702f1653c9f676a9bc8dd1836fe40c24bb7d2c44791738a473"
    sha256 cellar: :any_skip_relocation, ventura:        "eb67d25891da35ab74be690ebcdabde3aa18bbe4556eb3aa14ac227af502e15f"
    sha256 cellar: :any_skip_relocation, monterey:       "86aeb74d3d07b12f657454b247bc4fac9130fabc06df080108e220adc752d076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9776d06e0bc3947ad90f84092032c95149c285c900de2b644d88df51fbb41131"
  end

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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/e9/8d/31b50ac0879464049d744a1ddf00dc6474433eb55d40fa0c8e8510591ad2/pygls-1.3.0.tar.gz"
    sha256 "1b44ace89c9382437a717534f490eadc6fda7c0c6c16ac1eaaf5568e345e4fb8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
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

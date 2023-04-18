class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/c2/cd/d0d1e95b8d78b8097d90ca97af92f4af7fb2e867262a2b6e37d6f48e612a/yapf-0.32.0.tar.gz"
  sha256 "a3f5085d37ef7e3e004c4ba9f9b3e40c54ff1901cd111f05145ae313a7c67d1b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950d8ab709fa1abe814841604705099fd1a668025a1ec5c903b59f7f53c9a4ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950d8ab709fa1abe814841604705099fd1a668025a1ec5c903b59f7f53c9a4ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950d8ab709fa1abe814841604705099fd1a668025a1ec5c903b59f7f53c9a4ef"
    sha256 cellar: :any_skip_relocation, ventura:        "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, monterey:       "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, catalina:       "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c422cc9a467113710a17a468443733350d8f330932b03d77c7a98d11d3e68e"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end

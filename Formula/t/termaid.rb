class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/6c/5c/e2bc0d27c30de7a55a1c7fac8326454353058385864c5cda4a0d9d19ec59/termaid-0.9.1.tar.gz"
  sha256 "e81ccdf92590182873b5a6437d709264fd70611a91f130f14418e80fad4c7ecf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a1095535fd0344ee263417054872c4533846151ca5a4efb3c61058bfdf9716a"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"termaid", "graph LR\n  A[Start] --> B[End]\n")
    assert_match "Start", output
    assert_match "End", output
    assert_match version.to_s, shell_output("#{bin}/termaid --version")
  end
end

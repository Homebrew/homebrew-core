class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/2c/fe/dd5d89c1d5ac2795e8f82fe0686dcadd370dacb6020f6b45c51ea547c0ab/termaid-0.12.1.tar.gz"
  sha256 "4bbdac66ba795c26fe1d4028d65bea77beca41daebe4095f706ebd0ecf6b0482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97ee065db98d9b45056dbfb5e0cca80571998a6017b205e1db341c83b8b2308b"
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

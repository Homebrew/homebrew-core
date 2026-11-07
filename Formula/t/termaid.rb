class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/92/fd/0557e3ec30d4a6df6be7a95f193be90a1ef4cdce9cf00f31fd610ff27466/termaid-0.11.0.tar.gz"
  sha256 "dbd668af7705637a8c5c56d035ce39edc2cbadd417c25d91aa7260120d13a434"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a12bbb4b54c9655e978c6098f320d2dadd3cd9761637c4b3b4522a073ff7d78c"
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

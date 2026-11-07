class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/fd/5e/5f1a8e99de2cb3be31bed3768bd11a6ddc9f108cec17684a3d927f7eb61a/termaid-0.12.0.tar.gz"
  sha256 "37a44eb453671888d793e2c126a89f2d5276ad71c6dced16e53a161be29c66bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1399929fd957f02a817383e8498cccb7fb0c1c6d288d32968aec96d024de9a8a"
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

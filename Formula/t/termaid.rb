class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/9b/22/31d8f888a38848e7e17706992e34ce426318adf385a373fea5bd88718d6f/termaid-0.14.0.tar.gz"
  sha256 "85758e7e6fe6e81b00a9aeef1dbfc1a462984f7d95bc9feb8ba64539d14af79e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7df91ac8b37eef091e71b54b18ffc4a5c08f20e6a65f9c73d881ef4fade29204"
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

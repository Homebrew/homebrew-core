class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/1d/8e/f8265c9229f5b1fd80e0b8af1fa09495c822048d434bbf011276686fabf9/termaid-0.14.1.tar.gz"
  sha256 "7cfe898cea57ba647a1ac172207620a6c80ab0d5ca2418e2b7c97f0c31c68814"
  license "MIT"

  bottle do
    manifest_sha256 "3625ebfeec5a4553c6d5054370597a106dcf62206ea6c81ba391a68fc6fa37ad"
    sha256 cellar: :any_skip_relocation, all: "83392319bfea46ef1ddacb8fd1e2448ac94c09074a2bdbbe016dfd887032d782"
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

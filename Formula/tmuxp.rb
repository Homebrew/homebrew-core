class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/b5/7b/321352ec6763e80fdd2e0ddd0a406c3125d1e220d9063174246031fd578b/tmuxp-1.15.2.tar.gz"
  sha256 "9b6bd7ab29368f6b4c96c4b9dbeb90be58e687300298728c134197c404b5a777"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b0c7a9222fc630f4a8f2120d4004b41fd2550bc653cb4b387e1c99f19999d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfccdf61d55e542b463c13bf2b76d65686a59d8559f23181576f39112a1f0b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "4169c09c7b2279fd724b3048aa3aab8f09741e59918fa7dab1608bb9b4fb0bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "74d37c970680c2e2205270d249ed0c25b0930e5f936c12fba19cabadfc7bdd6d"
    sha256 cellar: :any_skip_relocation, catalina:       "f8670776da89b8300dfd2a1a34ae0100735237793feb82dea93e5ed2b873e621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e046bc8584fc3df41b74f8e7c7b36a7d71ec9804a15144368b369f0ac8b1ee4"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e7/ff/57093d287ae579f4fbf357a072b92551663cca95588c4835a86fd0130ff3/libtmux-0.15.7.tar.gz"
    sha256 "dee2a138e0eab14256472d140ac816c923c303406b894e27c068cc39f5f8bfb4"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end

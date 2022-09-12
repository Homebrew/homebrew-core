class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/bc/7e/3e13a95122e86f552f34a3a2edbbba49e87a057479f41358b6c4a7bf7393/tmuxp-1.15.0.tar.gz"
  sha256 "2f41fdd7d33d1a067bf4def70657300deda1e0185455949959ea449b84970e5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e005cb91b2c085572a88895c5e1284f1ccbd2131b294e0d550339be83b4c6945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20b493ed523be9473f93cf2cf2f40c6e1603fd29362e8304ea9b57653e34a553"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a5a17040a8c7d7af9ad48aa81db6f1081bf8fb09ec8c8fc8ad47f77bd53ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e0b048bdf88602de712e89144c4179f0feca042108bb9a56a1fa7773eb07344"
    sha256 cellar: :any_skip_relocation, catalina:       "17900eb2d56d5cdae1c46a479ab81477e648093c396b365c7e708914da301efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ebe09c7580c410b2351a1cb792e6ef87394f7e2f112f0bad7a6be5edaf72d4"
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
    url "https://files.pythonhosted.org/packages/17/3b/f97a9919864f929265decd41a30bfebd63cd26c035e11cb415060ad3b811/libtmux-0.15.1.tar.gz"
    sha256 "54d2ee820be23a56dd1d520eb7571d79260192afedeb59098c47970a6f236c01"
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

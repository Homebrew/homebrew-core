class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/35/d3/b8fe5cb0bc52abf33f8d5846a48bbca0ea35a3e1a3ebff99a8cb3dc1692b/tmuxp-1.9.3.tar.gz"
  sha256 "91a73dceda6c6fb700d25e9d21380ab8af4ca84da1e7086a0324f498d409c39f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "183afbceb21f4243c6dfe52488729609d7050a6c2001135f383f1c9f9cff053a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8229642f59994f54b32f26884562e6a1f193d5090e4476e878b3c94f76661b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "c95a4f033c628832d35cd60af56e32974956fdacfe4dd560562705783314660f"
    sha256 cellar: :any_skip_relocation, big_sur:        "415239c2e8fa77df2037039ce6d4e5fd9310c9d7dd6ced1ee7803e25e55d1b78"
    sha256 cellar: :any_skip_relocation, catalina:       "48c01d647c3e0d647d3ecccb03b2f4b989f86029b33365551dc1224e971fd059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9dcee819171130fa9bc31b3cd5135c8c1f6f5c87d818dfde465ff19572dcec"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/a0/cb/3c70ea96fe50678bb0aa3d2f83413c33f2552fcdd3ea274ef162d1ffa08c/libtmux-0.10.2.tar.gz"
    sha256 "a0e958b85ec14cdaabecfa738a0dd51846f05e5c5e9d6749a2bf5160b9f7e1d2"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/35/d3/b8fe5cb0bc52abf33f8d5846a48bbca0ea35a3e1a3ebff99a8cb3dc1692b/tmuxp-1.9.3.tar.gz"
  sha256 "91a73dceda6c6fb700d25e9d21380ab8af4ca84da1e7086a0324f498d409c39f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ebfc50060a48bb6645677513db2fa0df426734ad4fa1f20faf96577ff7a5259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fe8bb7ae7c9a38adb379b3aafd3a4b39ad9a0ba563bd21bf343d905ab784282"
    sha256 cellar: :any_skip_relocation, monterey:       "d8e6efaa62405f67afb315af0fd8fc7cec8c959984d679ec528d9dcac624707e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9854047cb7cbfbd4114181615492dd70112b0e3b494aa69c05d1e73be03e65a8"
    sha256 cellar: :any_skip_relocation, catalina:       "7918cf217ebd16d140cbf4382effcb854477007532e0d5c238267dc86fc21fda"
    sha256 cellar: :any_skip_relocation, mojave:         "313f346093b0516f4324bf02f1b55c29498d7dd4ab0412184c61f5f4928fcced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2198e006323b1d058fa51a5fd8e87336ce485fc7ec8a6cf718fcfc2cbad3ddf7"
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

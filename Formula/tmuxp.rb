class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/99/d2/566141c87e90362bb5b92c6f99013f3cceea566b752f9746ae78f51254cb/tmuxp-1.9.2.tar.gz"
  sha256 "dd19536c8abb506bc411232f9dcabdedb863270f0ee26fb468555980140ec243"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fe8bb7ae7c9a38adb379b3aafd3a4b39ad9a0ba563bd21bf343d905ab784282"
    sha256 cellar: :any_skip_relocation, big_sur:       "9854047cb7cbfbd4114181615492dd70112b0e3b494aa69c05d1e73be03e65a8"
    sha256 cellar: :any_skip_relocation, catalina:      "7918cf217ebd16d140cbf4382effcb854477007532e0d5c238267dc86fc21fda"
    sha256 cellar: :any_skip_relocation, mojave:        "313f346093b0516f4324bf02f1b55c29498d7dd4ab0412184c61f5f4928fcced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2198e006323b1d058fa51a5fd8e87336ce485fc7ec8a6cf718fcfc2cbad3ddf7"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
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
    url "https://files.pythonhosted.org/packages/6d/a1/163e93ac885db77955f333663edf010c5f6fab3bd5e5f9aac639a917993f/libtmux-0.10.1.tar.gz"
    sha256 "c8bc81499616ba899538704e419463a1c83ba7ca21e53b1efc6abbe98eb26b61"
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

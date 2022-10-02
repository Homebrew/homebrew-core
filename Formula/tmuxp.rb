class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/44/dd/08e4846a14d9f7d10281be0dbbab2ed238dd7d4d8faef267fa5441b31c94/tmuxp-1.16.1.tar.gz"
  sha256 "c21b232112c0e4efc0f0d39f73f1593d761efd04b804667e2fcc3024084e8d59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64eaa10a1387a1bea759f4191220645987bb9e706e84cb36c4e57eca03458efb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86a0fe6dbe086f9d3476b9076e1062463ef7a14df6d7affb2c89c0411d489912"
    sha256 cellar: :any_skip_relocation, monterey:       "26ba68b47654613a42c766f1df17bd083ee9fc2b1ee4efa2f0c1bd466c234125"
    sha256 cellar: :any_skip_relocation, big_sur:        "8302f1ef1b450971570a8dcc6a40a0cba6e6605dbcb1f71b64426c590279d702"
    sha256 cellar: :any_skip_relocation, catalina:       "be126b97fdfee74a090c53b7dc79d479b90d0d5d0ff3878f65b14375c6a60080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5e186200f19cfea1e60e3a8c590c50f3d725933b4cfd9e10c1f82b62f2889e"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/35/1f/c3dbf187f823e80cd22ce4bba3d52857b0c0e6775310c14ac5f99417635d/libtmux-0.15.8.tar.gz"
    sha256 "cf352a645ebeaa5046ad0593cc01d691d77f8b3af1660327a6433cc6276ab796"
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

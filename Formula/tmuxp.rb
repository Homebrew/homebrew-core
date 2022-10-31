class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/55/81/a665e6d24442ccaad0d99e62ccaa2842d90b7f372cb293d80480ddb5852e/tmuxp-1.18.1.tar.gz"
  sha256 "7923a26da7766d6359e044a79029d3f882dcb7a2a9f47ffffce72f3ec708809a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d71d2f97c0993ec6bfb02cf80217f1d90df6bd6e049b8ec373c138857e68f3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70a8a4080302f025ae48e82d1f57d96a8ec6ad5667c5a6bca6f16c575ba94d17"
    sha256 cellar: :any_skip_relocation, monterey:       "558306771b978171daf252c78e21464f8a91461e1acf14dd1649ff537a39d240"
    sha256 cellar: :any_skip_relocation, big_sur:        "99c97b6127f0183dc0570fa7f6d47431170863935ee02b622186745d014b906d"
    sha256 cellar: :any_skip_relocation, catalina:       "979cef7ca80088840e63b651662aa5dff2d4a8fe636b5dfcefe36eba066f9058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0889bb9fff8bd413fc905b651c9fbdf66337f08e395cb70ffa47d6813514a2"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/5a/94/3dd79517775cd71f10b3dea976222c001fbdf42e17551dcbf3893945a85d/libtmux-0.15.9.tar.gz"
    sha256 "da25358ae555c2a7f38ec764aeecf525fa3a9fd37001622877070d4de3b4addd"
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

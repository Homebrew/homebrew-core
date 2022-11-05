class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/5c/f7/7769dc16ca15c53ac17cf63bbef3bb72892f6ea717dfab8b0690ce62ebec/tmuxp-1.18.2.tar.gz"
  sha256 "8c1543b5b3d43e38d55de3b38ef45b9a7fe33359dfc9d6c7cab9067617ca87b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01d470e6d8671602354896e566f7827bdc1c27b489b81555c025623434a24698"
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
    url "https://files.pythonhosted.org/packages/e6/70/95d7016b1749e3c8fa5f7cfcb054560adf815a4aa9929a0afeb994268b32/libtmux-0.15.10.tar.gz"
    sha256 "c40959c5ae9e7add705a3c4e60365667e65ab45835a9e663692e428e1d7e42e2"
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

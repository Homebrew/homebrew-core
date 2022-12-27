class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/df/d4/3548a25095740cc6e85e49d5ca10710c8e9d1532ad4bd653b88f71593d50/tmuxp-1.20.1.tar.gz"
  sha256 "1c56397503f4855c9d2f11f4cc3bf2f2e1c5a00657e9d699bcce76b127e0f528"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0fec68592b20a21c762f582f017ddaa0a7a46ac25cf500f448dd67a57b9e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2495188df16c96912aa6cf059a9ef665e56e53837c8318a4795103eba30be33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b27ef187d293ae13cdbdce75cda60ef8222d549b68338a0762a2080659229732"
    sha256 cellar: :any_skip_relocation, ventura:        "668b415c0356afe763a754078ca9ad693a34b5dc87d998bcabfe4e6e0d3a86c0"
    sha256 cellar: :any_skip_relocation, monterey:       "177d84ab3249defe282557def26f6fbbede057c3666fbd0121eccf0398039afa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7c43e0b30df5655f5f29853bcbeb23593ab1246618678934bc71448a6465b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843cfae7eaf01126df32c6063f2fe7afc0d2bcf43f6468228fca3a51993d498c"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/43/5d/d816098db263e784b08b200915eb797d5b2882d544c1e3e099eafff7bec8/libtmux-0.17.1.tar.gz"
    sha256 "0282d1fca4eb237f749d4933c24db107078fa1d306a7e3bdd3973c594fda1054"
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

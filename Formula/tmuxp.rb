class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/39/be/d1aed5b92310ffef0cada87fe115ae9587ee8c8d18e1c4ba37ceb9879e7c/tmuxp-1.17.1.tar.gz"
  sha256 "60df9d935ee37daee564bcfd13a2c219f1634d7436a932e71486fd6638edd998"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba159bb96040da045a0c7fbf75b1363f21fe55b75802842bd2dbdf4e4d8b202e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0be797d7620ac3854ec47d1f80f08165e14de8b8d730406999544b175e2c3c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4886f3312782025ee0c0e6c5208b700362196474edf4348e2c122a14d382d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2fe3aee9f20c3205a64fe62ff281aaffe928937c7164222cebf8e4e2f0974c4"
    sha256 cellar: :any_skip_relocation, catalina:       "e4121153f67dcc6795f7fdceb901440ae6e151f05c6d6964114771bd54715bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76cb5c562b9b328d5a476893a090544beb94e77c206020206b1233ffca749ac5"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

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

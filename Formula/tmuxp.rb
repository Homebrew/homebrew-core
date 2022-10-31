class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/55/81/a665e6d24442ccaad0d99e62ccaa2842d90b7f372cb293d80480ddb5852e/tmuxp-1.18.1.tar.gz"
  sha256 "7923a26da7766d6359e044a79029d3f882dcb7a2a9f47ffffce72f3ec708809a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fbf33c91ba2fc6e9a5687ac780298e1f9ba4ef0764d0adb14434cf95db70942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "147aa9f228969404ab1275c41ee8f01ddeb1b7afa8672ea7aa84e0e1f27e41d8"
    sha256 cellar: :any_skip_relocation, monterey:       "54d867b9784518231b201231d419f296a1740b8a23ceedd204daa18d84d0c875"
    sha256 cellar: :any_skip_relocation, big_sur:        "61bd774a7508868759be6dfe1b357dc34a0ea59380b20b96bbc977dc9842e3a9"
    sha256 cellar: :any_skip_relocation, catalina:       "0b9f2191ac89d38515eb857e3a5d073163641def7222d997c67f3fdb2d06f7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49a28481f953aa4eab401e89a7d34c1d27fed406b9fa0b30adacdccc4ce476d"
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

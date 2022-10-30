class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/f1/3d/9fd00c6e631fb3318a7c5cf03a96c9e1b311b3006567f2365b6207282ef5/tmuxp-1.18.0.tar.gz"
  sha256 "374555a259370837d48b42674e621f7253714567e5cacda0a9d477a4f2bb5a48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b78886a19c73a45190cadbb12787fc42b06776c02317bdd78c43cd51592f8bd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ba6ea23a4eea10a73d2ad2183f8e059c7832c16667399fc2174ba5485a1956"
    sha256 cellar: :any_skip_relocation, monterey:       "ad07b8164ff812d24e5bb2fed74db8f3c639a5271caa116cde0075c0ab15ddbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e231a8935aed17578582a482e1c0cfe6c912af039853352bc775405a883ea370"
    sha256 cellar: :any_skip_relocation, catalina:       "ee9d3d9da6b6fc57ba39a47b04416baca26c27324b9e45ff97d53f98e6f9dd54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f96c812c72ec26f78f33a59f2c7dfaa4099cd2e798cee992ff3aeafe44bf3fe"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
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

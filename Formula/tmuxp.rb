class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c5/fd/e407d794f8512e0c490f147ab3626780a106803f45e95b11e9c08f2bb6df/tmuxp-1.20.0.tar.gz"
  sha256 "e0337874a5cbb5d5e6ba1d70c50a921a413a776c684fa688649f636ee9d0a51f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc46de41f0d0c328dcccb5b8db82bec2c2f261c1150f9458ac7b1691a7fb62c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2290fba7f4016b16bbb3048b94812bdcbce77c3707741f256aab5a0a7458a64c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18609d6a41795cdad37e5aa46ef771f48b80de3d806f5c6aaaf3b3145f1e940b"
    sha256 cellar: :any_skip_relocation, ventura:        "2357163d075a87356cfd3f8c57f0189340439dcb4f27c203895919e3d8c76d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "c6170bcc20f8d09600a4f9231ae87385ed03022e52ff2724219bf693dde8ebbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ef8e7e9319b832c12b7019304c5584629ed466d70c6496bc878ff05e709c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89682a921b13af82d9a5f634567f3a2281e659c9e269c270db761a8a7a553436"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/4a/1c/5c008b7e1baceceb67153f4bc0bb703c8134673fdc948e8c998bed70e137/libtmux-0.17.0.tar.gz"
    sha256 "da270c286198ce85d30ce6a6ac7b72e54de646b6097faf006b3a2ebd68eaee38"
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

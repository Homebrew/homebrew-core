class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/59/4f/8ce51b546f6d528003e7cc20024b394b6db1261a954d4a757bbb0901da9a/tmuxp-1.76.0.tar.gz"
  sha256 "aedad329c5934e9380eecf43e4a9372f4f87cab640c9695105e1e91c9daec96f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "816561b8fc51e06d1534f0760f871efb1752e58b00925695c6b73a1359ddb814"
    sha256 cellar: :any, arm64_tahoe:       "0032f1f5f4908b34d3e4514ae1c2f2c556e5427f90b6e9057ec043691e06c941"
    sha256 cellar: :any, arm64_sequoia:     "5c3ae769f968b9e5a80345a25bc8095b33afa26d0d91fa3968a0ae6868fd91c1"
    sha256 cellar: :any, arm64_linux:       "6989e47f0961bd3c483b400ac32643377f870d96cf699cde9344e608b4459fcb"
    sha256 cellar: :any, x86_64_linux:      "a51857582e37e31c0122f19949ba7f6fbb83dbc8af7791e59e2a5cf544eee451"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/0c/b8/0410c8487f7673926d141a5aaaf60133984a564b3c90eb4f3f99e92e7740/libtmux-0.62.0.tar.gz"
    sha256 "41e9e80602b2656fd119b13253b27bad46af5cfef32099be53cdd391e2936b61"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end

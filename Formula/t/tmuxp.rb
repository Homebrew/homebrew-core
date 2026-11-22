class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/84/f0/c9f21808c1e3860eb0a41b6028a8ff4bd1be8683d6f89efeb27cdf2cb2a7/tmuxp-1.77.0.tar.gz"
  sha256 "6827740ae6486a2e6a70162fa225500d0757691d3cac65f797bfaa27843d49f5"
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
    url "https://files.pythonhosted.org/packages/14/97/66cbf7647322a8a203c04ec6acb452976fcba72bbf68021e8fb9a5635c56/libtmux-0.63.0.tar.gz"
    sha256 "c1e340fcaa385111e57c674710c4ede42b9575811c145aef08b0618353b118db"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
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

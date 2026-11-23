class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/84/f0/c9f21808c1e3860eb0a41b6028a8ff4bd1be8683d6f89efeb27cdf2cb2a7/tmuxp-1.77.0.tar.gz"
  sha256 "6827740ae6486a2e6a70162fa225500d0757691d3cac65f797bfaa27843d49f5"
  license "MIT"

  bottle do
    manifest_sha256 "28e5566226da367a67af7ac001d6bf98b386fcea7b247233f28df96151ee042e"
    sha256 cellar: :any, arm64_golden_gate: "1119bf00635d1094c51fcda1a6dabee3a8a9c9ba47d0fb1be2734e94c84c3c96"
    sha256 cellar: :any, arm64_tahoe:       "0840677d395e23c5cf20f48674c7d47d8a5ef28a1861a97eebd6e98be420821a"
    sha256 cellar: :any, arm64_sequoia:     "66c14f92912753c9f156df2078cb72d44b6b8d6cb2b907b23f2638aa29c1602a"
    sha256 cellar: :any, arm64_linux:       "f8a1560e8289dfdf553f8c184b6473a7f2835f64407437402521fe908b0bf56b"
    sha256 cellar: :any, x86_64_linux:      "8212e8a997e25a86249d97a00a815900e6b72bb2bbe2ddcb656d38e4b50d644f"
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

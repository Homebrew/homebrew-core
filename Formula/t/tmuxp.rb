class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/8c/ab/a6d4bb9611dfb68367b406465022f3da21a1e5819dab870e4c6fe32ea09f/tmuxp-1.78.0.tar.gz"
  sha256 "3a4331b48ce455becd34a8c3cd24eea2879dd4533cb9606b9bf808d924be6736"
  license "MIT"

  bottle do
    manifest_sha256 "ffd1a4455e89994b70b37a38e8f46efea604a7fed77d235bd75bad51562e77de"
    sha256 cellar: :any, arm64_golden_gate: "412d874e0dac5233f90912fde728441f59bce5de062d636c706cc28ba3718119"
    sha256 cellar: :any, arm64_tahoe:       "2c2e1541cdc710c52d9cd7af113ebe72a4ae0da583b3ad68b3e838e0c0a70fd7"
    sha256 cellar: :any, arm64_sequoia:     "644e6a5b3f7bbe75341ae003877e7d7c87a75e430745597ebfeb83aedb5b6680"
    sha256 cellar: :any, arm64_linux:       "9d6b442f18c785a6747e4039e9c2f41da3140a7f49c383fb397ceb3587ec98b7"
    sha256 cellar: :any, x86_64_linux:      "549d8456f761970d63af7e0b6139f3e293e1b992e93bae1e8bfc934b2f8c3949"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/63/e7/f59c1f249f5c8efe6fdb03b90e3198c882d14aefe4da9f59ce448e209d83/libtmux-0.64.0.tar.gz"
    sha256 "f0dac5673c60dac3d596b505734e9ac953f6516a64b9eea6d437ab348019e23d"
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

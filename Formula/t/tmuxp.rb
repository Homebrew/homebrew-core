class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/7b/53/dbeef8b03336fc0060aa89789b3f72c6f49277f97ac70ac489681d8f6d3f/tmuxp-1.79.0.tar.gz"
  sha256 "f6434c262318ec9fe45c2ba2fc9825da2a370ec46fd90b09d436c46128a22508"
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
    url "https://files.pythonhosted.org/packages/91/5b/87d6619624341b8b1bf6292bc96774f9623c906e306443305eae9c992e16/libtmux-0.65.0.tar.gz"
    sha256 "b548892f13d704d63a0dbb81ccdaae429060586378619c450394f73a205135d1"
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

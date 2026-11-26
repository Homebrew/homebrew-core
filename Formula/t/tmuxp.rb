class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/98/de/27a37af2541bc544beaa03cc04ff99d572b768a7d25e08b9cbbe443bf2d3/tmuxp-1.82.0.tar.gz"
  sha256 "c8b1d88942b27ccab222ed169e494cf2fd4001b4a6b35028e1ba30aa80a9c27a"
  license "MIT"

  bottle do
    manifest_sha256 "32053ce07e9043ba8b55955070af77919a78d75328165902762e7bcb0d279608"
    sha256 cellar: :any, arm64_golden_gate: "5b9960737d9ac92992f0b8a56f78bb7d54709f400f659a5e8ae15ffa5565eefd"
    sha256 cellar: :any, arm64_tahoe:       "eb6a29ee467d63d182ec6ab4da1cc345744c4131f8f78947fe14c5fc759b8bfd"
    sha256 cellar: :any, arm64_sequoia:     "5b19471bad00245d3c6c8407503ba7c19ab9a113835ef7e285e9801401d551f0"
    sha256 cellar: :any, arm64_linux:       "4424cf8a7c1dc88f6c14a38ae4e9400d7a2bbc7f448d50296a1ace3f9e365fc4"
    sha256 cellar: :any, x86_64_linux:      "36b0f8d0d0dc1ee4c487eff88bf32c2c99b24cb63c12cd05c76376c165b05da0"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/d9/87/2f05a4cd7f89d4951db975be2c627ccc8ac2d0fe1a4b0ac819c49450fe66/libtmux-0.68.0.tar.gz"
    sha256 "730bff45c4dcfb4d2094a863d28d88aca81d6d8de6c1f47a79f0ed6a2a18be4a"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/78/96/6493430a31ecb2c6e36292b758be70655e01802575008d0de77d728f271e/tmuxp-1.74.0.tar.gz"
  sha256 "9e0480ea012999602635887e0461d395c2d8aa6e36a85b5a6d1d65dcd6c7809c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "fa959dc7799708913214eff13c8a772ebb5e3ad27feb37e7df967edf7396994b"
    sha256 cellar: :any, arm64_tahoe:       "1e62fd7fb024ecd0ee4326e44abee84078e574fb083d2ddae2e763160f4ee4fe"
    sha256 cellar: :any, arm64_sequoia:     "01d21349d338bf70361ac1176136ff4b711ea1b711c374fbdd984fbb665da0d2"
    sha256 cellar: :any, arm64_linux:       "192c2bcc002c9f09ce65b12746a08b1e71d90cdc55e8556eb2f18463028ad528"
    sha256 cellar: :any, x86_64_linux:      "2a7d3b9df4048207820b483eb21981cd1476e7aa596b22a0f1ca4b493845d850"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/72/c2/6abbac4420c35b3f1140c72607117236b160173f74fd86941f99b28375d5/libtmux-0.61.0.tar.gz"
    sha256 "2d6081081a629b9236a36a64f874667533811d2ce5a1b0caa9c821f4d9d2e618"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  # Fix help formatter shadowing `argparse.HelpFormatter._theme` on Python 3.15
  patch do
    url "https://github.com/daeho-ro/tmuxp/commit/d952c0b952c9b60767305d650e3c27be02861dc0.patch?full_index=1"
    sha256 "850b251caa765f7fe6771ce1a1c713c8fffecbedb66ac1368bd8c5ddde5ac50e"
    type :unofficial
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

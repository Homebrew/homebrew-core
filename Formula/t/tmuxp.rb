class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/78/96/6493430a31ecb2c6e36292b758be70655e01802575008d0de77d728f271e/tmuxp-1.74.0.tar.gz"
  sha256 "9e0480ea012999602635887e0461d395c2d8aa6e36a85b5a6d1d65dcd6c7809c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63cee943e0b571d3e20b5c90d44f2720492290732154c100fb351ca9d205b6cf"
    sha256 cellar: :any, arm64_sequoia: "5ba3c70cb34f756785ce49e6d2ea46cb79928603ffc12898d11f99f11250b1ef"
    sha256 cellar: :any, arm64_sonoma:  "13555b5edff303bd8181b0ff27302b9d34628d2a2501d7a2818ff8b049bc1f91"
    sha256 cellar: :any, sonoma:        "7e93a600dc633fc5fb7ce872fafd3053fad9e74d13cee810d5f4dee763699a48"
    sha256 cellar: :any, arm64_linux:   "592911b9d6b9261ee3d70af0d576d1fba4da2248f44da47814e51d735c3b4ded"
    sha256 cellar: :any, x86_64_linux:  "5c81803fa962cc0478d27f64beec0cf1a043db8604429b1ba467c6ca932abac4"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/72/c2/6abbac4420c35b3f1140c72607117236b160173f74fd86941f99b28375d5/libtmux-0.61.0.tar.gz"
    sha256 "2d6081081a629b9236a36a64f874667533811d2ce5a1b0caa9c821f4d9d2e618"
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

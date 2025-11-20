class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/89/1d/a272b6b2fc9bc55404705fc79143347211bd8684b957315f075b5139942b/tmuxp-1.56.0.tar.gz"
  sha256 "e8d73a24735933a39482839fa43e300835252c06f690b069966d488ee546feaf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdb4eeaec4a23bf906bf89da279f3cbeae8a408a35f8d98e5644c3c59f36c0b2"
    sha256 cellar: :any,                 arm64_sequoia: "743d2a92eee806c485dca643cc1530060273cd790aa8d906793b5496616d6d5e"
    sha256 cellar: :any,                 arm64_sonoma:  "b4e2972cd0ee0ac22ef05e0cb5bf6674e5197ebdb9c0d74b03e03c64720e8a1b"
    sha256 cellar: :any,                 sonoma:        "25dba888a3c4edf74a8443c7cd0ca3332c4c1b46ad7a7a020902c1c6e666579a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d41d4db9fd5032e0b50b087af46fb53af264010066a06ede39f0a1127d964f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1460a663e04a12e4eb93f1e309d44994c935a0914a46381d4069b4b66284836"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/64/b7/962d522112b20b4cb85e8d67c5338cbf3c487d3a4857de9538c6fbc3c9b8/libtmux-0.47.0.tar.gz"
    sha256 "49cce513498bbe7f1e5b29fd168b74b95815e869989dae74363d907fbae9d461"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/46/f0/df58a3fc9bd0cae8b3a2b1ddd16aa0c7d47be73acd5318a00e85d924783c/tmuxp-1.81.0.tar.gz"
  sha256 "70f8d0d567790903acb64967ba9caaeffccd6ebb2fd047a6028f4ef0aaa22ffa"
  license "MIT"

  bottle do
    manifest_sha256 "742362fe6b3405197a2689b4a2be1bc7f26c78b515e0a11be57f95485c5fe219"
    sha256 cellar: :any, arm64_golden_gate: "b168eccb9d1b17027e9097366c9da1d712e20c20a8e3c9f116289583283fe9e3"
    sha256 cellar: :any, arm64_tahoe:       "337aa1b10c138737415fa09407ea2a2241e11d016ad76e5acc492ddecbfff014"
    sha256 cellar: :any, arm64_sequoia:     "3954682416f509edabed5ec0fa3f4784827eae0a60aa666866dbf069e500235a"
    sha256 cellar: :any, arm64_linux:       "f788021c97095185926ffc9c68a0daba3df053109532a266c5cd68f22de5ede9"
    sha256 cellar: :any, x86_64_linux:      "c755c4eead87e86fae1c071801b2aa1fa855d4166ac5a6ff4edc16d0bd191990"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/72/f3/d33065929a6fe8c1005f34ebd8efc07be6fce4f068adfa3569005668b205/libtmux-0.67.1.tar.gz"
    sha256 "4de44cc40e35aed07cdf75f6f8d4062efa16731234ce8e2658d2f3b8edc20341"
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

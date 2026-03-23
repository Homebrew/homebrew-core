class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/3a/c9/43b63b5f0ddc53c25052de75945dc4adc6b14984a38e1dea72c34cf398d7/tmuxp-1.67.0.tar.gz"
  sha256 "990720d9fa5a6f4758790aecc201d2d29af0ad9ad8c47b58ac20acb0e8a94f12"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "440fbe888734beaf3d2432a68d2012b53b6f5d0889c08958c661f925cea71dab"
    sha256 cellar: :any,                 arm64_sequoia: "b161800ea7e7fa3c485306336152f082c7d51ec95a5bc92dd607f66208bf75b2"
    sha256 cellar: :any,                 arm64_sonoma:  "8a6a36d6a4402c70b4a05436ff0c44af7b7ac9d84b013d05654794ba89151afc"
    sha256 cellar: :any,                 sonoma:        "fb4668abcf46149e82ddc110852ab2ac50c19e8c5f3e6144430bf14dd790dc9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b346469666a047b31b4b1de3fc169f8bcfb2177db44f6786b39ba5a81d1606da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd56bb77e096df7254446408d3a05ec550176fd915c31684615a52e863bdfeb"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/f7/85/99932ac9ddb90821778f8cabe32b81bbbec280dd1a14a457c512693fb11b/libtmux-0.55.0.tar.gz"
    sha256 "cdc4aa564b2325618d73d57cb0d7d92475d02026dba2b96a94f87ad328e7e79d"
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

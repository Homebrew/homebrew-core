class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/31/cd/891706fea235c6298b472345108d52c8652dc95e0a8723beedce19f0f0f3/tmuxp-1.59.0.tar.gz"
  sha256 "a801caf10a0972e2455866d39e3daa3fc9d87140022bcde0747ee275e3429f5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81657391f7748fc9245a3ab33d35aba734092ca5b528c5f8e4bc1670a75720ec"
    sha256 cellar: :any,                 arm64_sequoia: "ab174cb670441ea9e1fbef811b36124848358f9a4f44401476be04ce9494fcad"
    sha256 cellar: :any,                 arm64_sonoma:  "d7595424e36c8ddd450c3ad4c20a1a40d2ed7963f96a0a3fbd30b4042c25de66"
    sha256 cellar: :any,                 sonoma:        "3b3d978694bb8301f1f19cf9ade4c8e33e46dadc66f6bfbf27bafa1bdd56d2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c8cd41b1108bbdb645f7141ba2ad5995c321fc1c4b959d1a6f28b1a269780a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b3f71325a2a068100822414bfd64164a55b14312de3e686f8e679466756ef9"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/8d/70/2c126dc1253c674ae01e89d63078f9b6a6ff3c6e224bfd1ca1fd3108751f/libtmux-0.50.0.tar.gz"
    sha256 "7e3ae83e7e216903b311d7db25b3d736a1cc3ae61469ff0d5b6b563f6a92c3c0"
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

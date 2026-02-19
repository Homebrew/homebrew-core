class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ff/20/0d381d34deb463c395dc655730950e1c1ad73b063c95cecb3f9090066bad/tmuxp-1.64.0.tar.gz"
  sha256 "8f1e5db86ab1817a831df73be2667a619971756d7a6d8277283e61451789982c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0da0070d80d97416e21644a41b422b152c407291f5da9e57001c237cd39de771"
    sha256 cellar: :any,                 arm64_sequoia: "fc4960f7ac2812b7e121f1c836f227233e39e5fb1d741d0a02ab9bcb4ba5a289"
    sha256 cellar: :any,                 arm64_sonoma:  "ad25a28842d95e0ddcdb3603fbd1b2e0d29c5c95ee3035a13612c08239291a15"
    sha256 cellar: :any,                 sonoma:        "d3858895fb3847dcdcc564b53d1d070b1ce1e2922f31e715e899f66d6c514f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324265d879e56844a47115c7ac2a02a4a17c7da7c9fd4730c6927a88c88fef39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13cc75bf4ae045347a2b51c262da51f7cdbf2171ab24790e3521f50c271c08b9"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e7/28/e2b252817cb181aec2f42fe2d1d7fac5ec9c4d15bfb2b8ea4bd1179e4244/libtmux-0.53.0.tar.gz"
    sha256 "1d19af4cea0c19543954d7e7317c7025c0739b029cccbe3b843212fae238f1bd"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ea/e3/80b5828fd233a86cb0dc43abef8df0a0e03c674ac8c2d4bc1a7726f7aa9e/tmuxp-1.27.0.tar.gz"
  sha256 "40093eadc3588e10209095f67dad1b977747ac1e32c9843fa0d9545f7210311f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a04489270cb9430a6901467bce1d055ae1ee1d9e8ade4fa0c0e9d9509effd19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "866cb3e09eceaba99f2ac80dfe44190c96d44f398adfae896289aefe7aef7c27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c6ffeb07dfcf49b49f4573239f4283a247b25918119a1faf86a9ef43a995b0"
    sha256 cellar: :any_skip_relocation, ventura:        "9d79e71ee1ecc1255dbac671725d8d88632e0caea1278d533e9422715846fc27"
    sha256 cellar: :any_skip_relocation, monterey:       "d88c05e350cacb35d855abc4f49f6e3b6b0b3630f7983597beb2b544911e5576"
    sha256 cellar: :any_skip_relocation, big_sur:        "7be6e6856d68d51f158dd69d55f00ed89550dc9f69d8db48e1ad86f67d2b7a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060589cd8ac47294b60b414fb598131505b614195854384af21972a131448083"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/1f/cc/aafedc34ef147795a3f044b12c169301d3cb8e5ff046901ca8237d4fa3d6/libtmux-0.21.0.tar.gz"
    sha256 "dc30b94ac25571c438a853ec75102fe5f1a2d7c8195b5ebdc6f71106760b15b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end

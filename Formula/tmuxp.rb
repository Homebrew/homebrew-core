class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/44/c3/6b367e516301bd90ce9f8a9f2faae171a576bf5cecf8aa1f5358011f6f4a/tmuxp-1.17.0.tar.gz"
  sha256 "4e63462a57e37d8134efeca51340fd4a91a28d0e2eff98e477afdc242c814b0b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f37cd03f8d398c620bfb519453012dee0455589ef7688c56d3a2b45b032d32fa"
    sha256 cellar: :any,                 arm64_big_sur:  "f84000d12a0d6a1b20dc007d32dee72512da33d8bd0d7681b1ac5a117afd0a35"
    sha256 cellar: :any,                 monterey:       "eb46ede434596bff670b36fd095acfbe47b1ae9ca08e4b79e7c726b4144d610a"
    sha256 cellar: :any,                 big_sur:        "e8116e8976be172a83ea3b10290b1b8d1b2d521b7513d9e9a9d2c50daaccb1d3"
    sha256 cellar: :any,                 catalina:       "9a7993a999afeffb416e27598c0aeb409abd9cb563f7da7f9ecf8c0694412224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d713b4b2793d0c1baf2312c0d9453f4ae29b30c5e04715e74f54b000ccfa8f79"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/35/1f/c3dbf187f823e80cd22ce4bba3d52857b0c0e6775310c14ac5f99417635d/libtmux-0.15.8.tar.gz"
    sha256 "cf352a645ebeaa5046ad0593cc01d691d77f8b3af1660327a6433cc6276ab796"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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

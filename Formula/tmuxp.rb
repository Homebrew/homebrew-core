class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ea/e3/80b5828fd233a86cb0dc43abef8df0a0e03c674ac8c2d4bc1a7726f7aa9e/tmuxp-1.27.0.tar.gz"
  sha256 "40093eadc3588e10209095f67dad1b977747ac1e32c9843fa0d9545f7210311f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176749c58209dbb98cddd31cfd59b9e2fa5fb874f0cdd3af2a779e9dff43c092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cb02265d001f32b0ecd33c95387becece49962cbe3622f3278f64620ea6c22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a99ddcd85bffd2f8dd1dbd192ef6a3e859f7385cbaa579442453be81c60f977"
    sha256 cellar: :any_skip_relocation, ventura:        "7b645e2f4952a162ab6ed64be702b779e1f23e1462a4189a29a26fd4968b28f8"
    sha256 cellar: :any_skip_relocation, monterey:       "78640fb6b3e7fc419bb443065805e96d911391ae4aaa71c098d44c6a9aab0b7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d370edfc5f20ba914eb76fdc1809e6d5d9dd2cad584f1cd5460fffa22989e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21d425f2f294519da87a46831959a5fe9a414320730ac90985a320036a69593"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/f1/3d/9fd00c6e631fb3318a7c5cf03a96c9e1b311b3006567f2365b6207282ef5/tmuxp-1.18.0.tar.gz"
  sha256 "374555a259370837d48b42674e621f7253714567e5cacda0a9d477a4f2bb5a48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fbf33c91ba2fc6e9a5687ac780298e1f9ba4ef0764d0adb14434cf95db70942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "147aa9f228969404ab1275c41ee8f01ddeb1b7afa8672ea7aa84e0e1f27e41d8"
    sha256 cellar: :any_skip_relocation, monterey:       "54d867b9784518231b201231d419f296a1740b8a23ceedd204daa18d84d0c875"
    sha256 cellar: :any_skip_relocation, big_sur:        "61bd774a7508868759be6dfe1b357dc34a0ea59380b20b96bbc977dc9842e3a9"
    sha256 cellar: :any_skip_relocation, catalina:       "0b9f2191ac89d38515eb857e3a5d073163641def7222d997c67f3fdb2d06f7e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b49a28481f953aa4eab401e89a7d34c1d27fed406b9fa0b30adacdccc4ce476d"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/35/1f/c3dbf187f823e80cd22ce4bba3d52857b0c0e6775310c14ac5f99417635d/libtmux-0.15.8.tar.gz"
    sha256 "cf352a645ebeaa5046ad0593cc01d691d77f8b3af1660327a6433cc6276ab796"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/2b/25/e696821e9d490ae3d5cfa31c70fd4589f974f5c82294fc043b57a0835be5/tmuxp-1.46.0.tar.gz"
  sha256 "f9a5e9b01e268f0f6c64b6a5bf79275bca243fe9a1d8ffe76d90a20b06b75015"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad733b336a0ee581915838100d724b2dac391d520d1b29c9b4b9756202dab71b"
    sha256 cellar: :any,                 arm64_ventura:  "0cdbfd7dfa6c5369f9be5e9dcd8516d569d504bcd300ac2126fb9ad6ad40fef2"
    sha256 cellar: :any,                 arm64_monterey: "b2143905fadbd9b12dd2f33a5a8bd0135ab224e03e674b9f72b83e0cb1394d03"
    sha256 cellar: :any,                 sonoma:         "f3ea511caa4a41a659a153b47495c3184ac23e0759b1a09f00699be187880575"
    sha256 cellar: :any,                 ventura:        "381f271a6a06da07b1aa3cc00c2051be462a7b4846ccffbce1647bc148d25078"
    sha256 cellar: :any,                 monterey:       "9857b34f47e29e1eef68308a6f583bd6981e686dfd26c0b799d88fd470bce603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "987e1dc108a0d51cc14b52c158c9f95e0b251154d3c571abc907f2372810f778"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/f3/91/921d6965e39d7c767515a0b1dce8d66948b1daf8deff629aeb5ef9cfd08f/libtmux-0.36.0.tar.gz"
    sha256 "12b5554b3a19d663d2a04f30b87fb063bd6456463a3ef6c6445a721fd7f7569a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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

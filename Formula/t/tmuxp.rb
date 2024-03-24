class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/a9/a3/1daa0dcaac35d567e2fa21522c3c1bdcb7b7bd96e56b9ed591cd046ca082/tmuxp-1.45.0.tar.gz"
  sha256 "23b3ff0a8862a44c2bc687a553f78f4afd8f1e03371d775555a7699ed54572b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c887c570333fe97adfa46794d0507ed679df3287c3d0e01a6a80e971f9bb4a2e"
    sha256 cellar: :any,                 arm64_ventura:  "8e3cb79d85485b4da34e0b8033c16ec6d5801324c18653fd9aa9270287ad679e"
    sha256 cellar: :any,                 arm64_monterey: "943d7067d213a0fcb92a45171c130e77babe55487358831f0793c8d5cdbc408d"
    sha256 cellar: :any,                 sonoma:         "84adae392346758e60686b8912b17634c1e372026e06d32e8cd1d14d7b520a2c"
    sha256 cellar: :any,                 ventura:        "1671f2ea358cc060b7853f0deae2d88ee8f6dcb7e70a57d07c0982fb5aea9552"
    sha256 cellar: :any,                 monterey:       "2ee887892fa1feacbe09e9e135b227aaf6893528db32357d3ec8b3b9a5e30963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bece2660d5073f3328c7eb3a6a84ae2cae1c4cd486c43ab51b259fe1eac0d5c8"
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

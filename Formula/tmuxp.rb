class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/05/fd/31dfd84dafc409f6f4d0c52ae33ba300114d100c32799a42916facc6ef7c/tmuxp-1.27.1.tar.gz"
  sha256 "ee8ca69828780c41f485eddd01f029602c4a13ed589e949f6ba6f9125bd0a939"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738f1e1ddaea21b16e1f0bfefd21b2d27532de96ba2db4621befe0fc269f6050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c4955f287c49b82b3cbf0a66f0c9739c75013a8e46332523d51c73d743fed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cdf6478ba24370e0bf8d34654caccf92dd99ea999f5ecc68ba0038973f9a60b"
    sha256 cellar: :any_skip_relocation, ventura:        "405c4bd65439e5b966e5a9a0ce52002fc74edec0e833b2c81974f1589133db10"
    sha256 cellar: :any_skip_relocation, monterey:       "c38f6d7f52348d38a240d2a93c9cf15b55b985cc1f695fa25fb703753012a8fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a0932ba5f93019670ee99992929210fe5652805cbea6cfae1b35f770b23d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971ae21d113ff5b950dc70f6f66fe4928724f38d3fbe111afa1b2048b8d1f80d"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/70/32/64702052328dbd249aff193e656c030d57a3f599df500fe5420ce53668dd/libtmux-0.21.1.tar.gz"
    sha256 "184d73594c29abe53cf64909c1bad4372cc94bb74f35fe26254ea521d3520af6"
  end

  # patch for version number, remove after next release
  patch do
    url "https://github.com/tmux-python/tmuxp/commit/be12d6b2d2f7d0008203cdd0794d030aecf0b64f.patch?full_index=1"
    sha256 "3729c4352aca45fa9c757f473e63dfe081f37672e70c8be9a02f1d5c5bec2647"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/5d/ce/153ee0397dd99bae47c3a6ce68f990d186f5c9c9d9f0c8b4d51b62cd0ad5/tmuxp-1.19.0.tar.gz"
  sha256 "18490797f1428af8c96176ff7a4de2b97b3ad15aad8f8adbd9e8e0e8e647d9ff"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0fe370d722b8b23a24f36109162180e61ef5e666bd8c0da0053165ae3c38ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51f01581f73ed10efbf05ec39b262d8168d438a40f83289a7705cc2d29fea41b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30b3fd7c18072d9f3dcccd47276a79f5df434578005b6fdfa7b8bfd89226d9af"
    sha256 cellar: :any_skip_relocation, ventura:        "1c3864c7c5e9bed64df369afd611f97a87071ce282a74067fc1ca69da4828bc7"
    sha256 cellar: :any_skip_relocation, monterey:       "12d12ea11f146ab2684afa006dd2fa28b4b81201691f8d69cb387b4ada1dc909"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4144e1ddb39d9c5d19272525bbfa2b4ce83d524a616c4cec5b1f21661af5d8"
    sha256 cellar: :any_skip_relocation, catalina:       "e8280bde6af288c1aeb9f9ccb53857c6178f800b2a134007ef7e0802836a41d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ad6e01c5a1eef2ae548be0510be169b7c85f31248c4af51d5b69663ac17050"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/6c/14/b3d944222c2ed5c1d14502258455eaaa570bf0c2144409249f53eecd5f71/libtmux-0.16.0.tar.gz"
    sha256 "10ee940b487cef3d98aa776af1d35f0ccaf13df7920e85f074069ada5fe50b53"
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

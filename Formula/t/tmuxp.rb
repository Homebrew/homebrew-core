class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/43/94/5f0dffe812c777c9705f4453c8f423a4c05f07949730be0cb2f6c15279e3/tmuxp-1.43.1.tar.gz"
  sha256 "5f10119ea195499616428797a4e3d7c191e4e7550fe0e2620a9d14fbaf5cff6c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "965065f4250b7d8e0cd90003811a9403c57550256822cb3de1c6a1c36d6b214b"
    sha256 cellar: :any,                 arm64_ventura:  "f33800d3d849d809ef79eda46c32be4ddf7e1515b3dfc46c92d43181c07c7b83"
    sha256 cellar: :any,                 arm64_monterey: "0e9772f67ee0bb9917ed5854f2c86deb22a3ca1e9ab66e164bd8c7db48b26ee9"
    sha256 cellar: :any,                 sonoma:         "06c7c257afba43d9b54a73c5ef85fc7a35787e04c774295b1eee8ca6bbf72b19"
    sha256 cellar: :any,                 ventura:        "9c8752da961b784bd50770d4b2fba725670199273b26f9232315cd56fa75de65"
    sha256 cellar: :any,                 monterey:       "2e6f379650be23a2657e82c04ca74dfc2ce948f72f56f7d3b0f03cc308a3e620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f82f7fb1910537e87bc25c04bb9de7255e134e742c83d2055f864718abbba4"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/a5/13/044a20fa080ab2ed96130fff99d186eb1c1c26cfd3d059f6f315ae1ef8f9/libtmux-0.35.1.tar.gz"
    sha256 "8c798d8e18eb2e3a4ce8b9ef5c25d5d9f53035abba2f7e6f5379a9a3effc6608"
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

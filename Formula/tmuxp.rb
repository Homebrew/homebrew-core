class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/be/74/a39de93df49dc4e46f4d5949bff104ba75d1fa9307868dc3f15473e49ae4/tmuxp-1.11.0.tar.gz"
  sha256 "379919f9ed7b6602ce0af57f95c4ff85d1b554da8bc61f7c40e4323340666420"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a74352b5d18764ae8421fb471a6254c69dd6c5c615413fe9ba13ae6a2e00bd8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37c2737b5785411b992dc252257a5f08b2a3ce6a2eff71b5a274fba73552125f"
    sha256 cellar: :any_skip_relocation, monterey:       "5efc57d47f6bded9ce1c0e034d037af762cdc1f36e18d3136e66e8969c8f9c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "8557009c78f3bd14cf59f8627956a1aa6c3908aa83b5e22999b855ddc25710ee"
    sha256 cellar: :any_skip_relocation, catalina:       "a11063948acedc5fb4503a8fc76e95c370dee87a0969c7de079525ab949bd4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e9b3cc757ac1581fe3e965c4d6b411aeb9f50de4a32736f567a9e7e7f89679"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/92/db/aa31905a3ba3d39890afb404528417aff74eb744222f03568e7a9d7e58b5/libtmux-0.11.0.tar.gz"
    sha256 "d82cf391097eb69d784d889d482bb99284b984aa6225276a3dc1af8c1460dd3c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
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

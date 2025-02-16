class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/68/d8/0658fbcd0f046cf8408427242c5f90a9e5d07a463e7f2e78a219cb0f197b/tmuxp-1.52.2.tar.gz"
  sha256 "71f5412b6722538ca2f5964d2c1b39731afa0e906daa1c5723b523cb6199bf77"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b16f5c8ba6cae144e717fec790477872eb341c209420ef4ee27a893892938315"
    sha256 cellar: :any,                 arm64_sonoma:  "8a4a711aa79d204b2452b00f4343ffecdfbe6df5cc4764380955d09c5a8634f0"
    sha256 cellar: :any,                 arm64_ventura: "73c3e7972ac5c9f86b7a61e33e5380d5c1f3e310bb9798f472881d29567e4585"
    sha256 cellar: :any,                 sonoma:        "a37309dee794fd5139600dde5944ea37a65c526a8fed288f38bb5a9ffa70693a"
    sha256 cellar: :any,                 ventura:       "b17042018f4882ce9a80ac2ea6009d32e9a95766a662cdea181e6bbc6b983bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c180dc927b9926d4824163546f50e6280bc57af50c1f21f0c9ac1fdd47a2ac"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/ea/79/630e2b1b271e59cc17988f9b5473ea17850555b7734f6df25be16f0bd6a2/libtmux-0.42.0.tar.gz"
    sha256 "5a13bc98d85fdb7105eea880d8f7017c8c4cca6563485972dd4550c57b66ee6f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ca/6a/a3200410d5a1ad6b7dccb416fdba080bb5924e536f5764bde3642f6ca58e/tmuxp-1.55.0.tar.gz"
  sha256 "ade0bad3d9d8d647664089c0a6101f9924d9410aa2b530fcf0406fff8994de1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "007147b2089ee3ecff6b52131c3fddd09482481589c4fc5fa3e94696cc1e6029"
    sha256 cellar: :any,                 arm64_sonoma:  "098592d2e112a37f51ced1279638016aec09abde2765c25833b0357cf06585eb"
    sha256 cellar: :any,                 arm64_ventura: "2efad5216e5848d0589bd982eb817e13d15b35b1f8ffe2ef7aeff12102d91c10"
    sha256 cellar: :any,                 sonoma:        "f3d6b14bc8fa5a9474963273666960b9fa51b449571eb933d2912e506dfc2ac3"
    sha256 cellar: :any,                 ventura:       "38b95a0e04c4205b5f95ee4eeeb334df76b6d4266153adcf49aa11781150eae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f144d32f65534681b8ae2385d7eecbab29a491d9533a1056a91c0315a820ec2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1650751946abbc08884a650d2761892329dfd1f90ec85b2a4b64a5f29ff805ad"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/f6/97/2c783d2217a954427d24743f9dc1768ec836fe84258405a964577ce75d36/libtmux-0.46.0.tar.gz"
    sha256 "65202494054ab2f6a72520a9f3ff0da29e3294af0365a96c51bb4a58cb9856ac"
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

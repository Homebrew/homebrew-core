class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/68/11/680c4a248cfeaec4aa29cdcbd988455dcc238c77f741ba6210f82e3f708b/tmuxp-1.28.1.tar.gz"
  sha256 "b0d2ea5326ace90635d5e5bf16192a07afaee0c4ea898d62c6f0f704debd1627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcaae295ef463f3e6a0421ffd56dc27237a52a596d5e5f1ae397e76463bf5616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07925a1d57d23b9d45e8469908de73c4febe51706c38ebea8adf8d6a5d78277a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac313ab4ef70dbe91589b6a7163aec022663f1a60fae5b464608b856a86cd5df"
    sha256 cellar: :any_skip_relocation, ventura:        "c3c67c14534ec386ab46e98d1a6d8dba50a4d879afcaa519d4029cb40d9d80ba"
    sha256 cellar: :any_skip_relocation, monterey:       "5e4c0e0342f2069632281a1c41ed0bc152633c72c1aaf30e970e5b88247eb89a"
    sha256 cellar: :any_skip_relocation, big_sur:        "730ddb6389ea1f5780954417b69b1c250f304a99473d2f054d22fe521b79099d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95934f0948abd72b7580f4ad2f7f68070a901bde54e19d8b1f3957371f345a83"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/da/36/422236fffc269b4338cfd3028705aefd97803ed8af809473eb38964edadc/libtmux-0.22.1.tar.gz"
    sha256 "794ce91bbe3c754474f06464bd0aed5e984b4d85ff105f0d0eaaaf469c02acb1"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/4a/52/d2cd0186d2b76b50ba81004629bec89809554ac782b991d6282de8eae4b7/tmuxp-1.39.0.tar.gz"
  sha256 "13c435b82577925e2b620fdbcf08e4dc235053fb8ff65119cd2a9c38590bad8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34d43b3ebe4979b5dc5be947437332ec28d5a16932139f7fb2b2fdbfd73fb34c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce3d5645027a9acc8b204e541cca4b4a71e89727041d108d9cf14d6342170b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7841f16b089fd2cbf6e9189e95564b4656b6b471c4b3af9eb57ef18c31a0625"
    sha256 cellar: :any_skip_relocation, sonoma:         "660be1f410bc47b04f317f8094229839beafa2f5ce43ad52e8a0c419b9381de3"
    sha256 cellar: :any_skip_relocation, ventura:        "291358b407433aa5fd93662e8e3322025e351c406dde125e0ba6ce8540acd51c"
    sha256 cellar: :any_skip_relocation, monterey:       "4057726dc1cdd47375bc66d973b512e959b265cdbd10cff8aeff8d34573c0164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fd18649e65fed61b02d4bf5989567aa783ddc98fe9f33a3f7e2530177f0a77"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/9a/d9/5da31caa48d24041c759255e10e8388c2eeb49fec30c8731f6b2a8d543ad/libtmux-0.31.0.post0.tar.gz"
    sha256 "38fd419a4e1088bbe6fffac73af00c0741b3a60e476a1fe179be746812fa717c"
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

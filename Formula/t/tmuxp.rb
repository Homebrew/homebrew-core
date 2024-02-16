class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/e0/7a/5c371e49624597c69e1b4cc91978ec6cc374eb1aa3174e872284516c9ed7/tmuxp-1.38.0.tar.gz"
  sha256 "96220a16f8cb807e7caa404d701c65655f22ea82260342a55e42070b74163015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02885db117864b949ca43040d180297e4dd04982ce9e9fb53cfc2917a62e76a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "857f20ca569dc9db93f7c75cb6e50a3ebef00376fbd4f8ebb9fe8cb47d49c5de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4310b19fbddf957e49345c296a63e3d4606e4ee058c5e2d2cd82f315bc17659"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bc4681b89209fdc4003b4b9ff91fd9e4b35901264a7c8ba1fbb1dd5f32128b4"
    sha256 cellar: :any_skip_relocation, ventura:        "555f191ae5b86f9dbf0eaa5b0f09e7bbb9fd2069a7ffa4d7ccbfdd34b9008292"
    sha256 cellar: :any_skip_relocation, monterey:       "5b7d1aaf890f86c30524e394b4d4c59095265127d5607ec8366069e4e4371b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7678117ab17339fdaeffbc8580f0e779f39e51579d98076aad882841049184"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/0c/f0/cf2b165b78b60166793ba11e50cb6ac92456540f8b4973c7cfd5355257df/libtmux-0.30.2.tar.gz"
    sha256 "0f6b41f99b1adf432ebaedc999779f5410c754910127d4efedd74e51b432afca"
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

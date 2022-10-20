class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/39/be/d1aed5b92310ffef0cada87fe115ae9587ee8c8d18e1c4ba37ceb9879e7c/tmuxp-1.17.1.tar.gz"
  sha256 "60df9d935ee37daee564bcfd13a2c219f1634d7436a932e71486fd6638edd998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b13aeeabb818e36a863265ce12716abdcc13b36c70db6fdb9b4bf70c41a025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf66f34b17498e4845525a4009628f7404421af94d1760a2737520f872fd8882"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef48aacc29f195c460480b32f7988a58667d3eb534843e7dc5a4f9d030e2e99"
    sha256 cellar: :any_skip_relocation, big_sur:        "aea0bf040c1ab1aa0307aba8a7cee0cccf4ca79f93331788179abf73a1023172"
    sha256 cellar: :any_skip_relocation, catalina:       "c9ca1ff7220e3a017b3eb771c5457665ed65f19064cb3e2aaf7799cccfcfff21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6163668034faf9a6067b93095e0f3ab863d9a22f7d44a4a67acf76c962298720"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/35/1f/c3dbf187f823e80cd22ce4bba3d52857b0c0e6775310c14ac5f99417635d/libtmux-0.15.8.tar.gz"
    sha256 "cf352a645ebeaa5046ad0593cc01d691d77f8b3af1660327a6433cc6276ab796"
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

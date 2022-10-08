class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/74/b0/df8299dc1ff34863ea4ee0bd6d63d352697b0bfea5b4edbaa7c91b7afb00/tmuxp-1.16.2.tar.gz"
  sha256 "c42399c042f3acb299a04b0027a14481d2436be1c26074356e89a0536da4c1c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "243d54fe764ce3ea64f948566211b341f2987e8e17ee094519b3564881c38f02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03b1bbe97c1b8093f434c46a5bb95583c0012d742dbf7c8f593588cab30b2a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "7c06017bcc6a8e8a00e1eb8ec87f2bbb9e70e4ed708975e90a8117650b55ac3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4d686771ebca936f1da67de72f15f658d0c49ae327919fcbdc26b18d5f9a1c6"
    sha256 cellar: :any_skip_relocation, catalina:       "6f1ac5927346d562e75e299358e028a74bba592f7f072bb4d0f2e5aa26d70493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4870f3336303426aec225be8676f1ec6a5b12e0faeaf931ccce5271f5cc9d339"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/35/1f/c3dbf187f823e80cd22ce4bba3d52857b0c0e6775310c14ac5f99417635d/libtmux-0.15.8.tar.gz"
    sha256 "cf352a645ebeaa5046ad0593cc01d691d77f8b3af1660327a6433cc6276ab796"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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

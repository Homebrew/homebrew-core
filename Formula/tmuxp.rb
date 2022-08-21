class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/25/53/dffb7e56169083e470cf6e748b590b6850119d25ca97395c08546cd38c87/tmuxp-1.13.1.tar.gz"
  sha256 "41eaa19f520994f93d7c74b5f90bcf1d94964a7119f820b3d66c815ebed4cb50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac4c378165a293f182740e3c0caabe0c8df6fc6242b6651dbb3bf24127636b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1c34b6e7b69d13edb16281d6d251382f992ced3e755472d1b4b9fe97d101858"
    sha256 cellar: :any_skip_relocation, monterey:       "639b33dbd07dceeb89c704a084de90c6c18e00c626df71d6ddb43b482f64e5df"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa5d200b9a6f0e04d6c90b581057c01eb056bbb39f9b25eeb1a0090ff0d2afcb"
    sha256 cellar: :any_skip_relocation, catalina:       "c091e4e26723173ffb900965077db40ab8c32808d6ad0633f73a4e0fa6dfdb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91571375d45f622e5f9e2ff9a5dcbe9b1184ba69d684334a4d9deb2b0ac335b"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/dd/0f/7d461d60f7fa613f50c15c1d92506e06fc59b2858386180de969e4236a62/libtmux-0.14.2.tar.gz"
    sha256 "38ee348a119c4f60caa9cefc66f15c5d0d46b8cabb3e59dcf22162f8773f8a48"
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

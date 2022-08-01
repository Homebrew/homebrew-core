class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/2d/b6/40c3bfcac44e5f05e4798ca81163cba0da5e8fe3e51aef06d4d75e3a3cdb/tmuxp-1.12.0.tar.gz"
  sha256 "73fdef331f5017c0ba1359be92ce83b52fd66a6cf84c7165925a0b380a734a61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe5a9dae300f31d27dbfecf8900159ff209eeae60bf15e40f1bbf17ef6523773"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d77ca0887e1f66ab18faf7fbfdc4cf25e3f8cd86304fe15bc40ee70283c5668b"
    sha256 cellar: :any_skip_relocation, monterey:       "047e2748eac8f9b0e8fdc6f1b3d6d9610bc59f60d73e040a54f72b7e07831cf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f4d68565b608f34430ac585be04f35c2959eec59bc4d7989b8006cb1330cc6"
    sha256 cellar: :any_skip_relocation, catalina:       "ed787dac9ead3d82a0339e1fc99d7ee4ec2fbcf6f38f4c8c07f9d9a88fc33b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f974b3f5a1e06df1b212341f07516003d1f8d603f8749d063a3bf89cf14adeb0"
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
    url "https://files.pythonhosted.org/packages/76/f9/81461ab705e3ae3736735e570ec59d5ea5d0d2f3022c00a4ac4b8fe6f0f5/libtmux-0.12.0.tar.gz"
    sha256 "881a38fb93fd5839ecdbcd2021e25dce4ea1d14431f46db894830c9a789af904"
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

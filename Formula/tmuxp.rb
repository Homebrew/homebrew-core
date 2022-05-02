class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/95/17/0d9ba4a6c8d11f043f6516f7c804acc211b28c52c7b1fb3e28bf175db052/tmuxp-1.11.1.tar.gz"
  sha256 "436d1fbf356510c21f7376628fbcfbdedce4e7a63ecc81640e58bd41a63e010d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d0b0523a04416aa0e9e94810c9570e17da7202edeba3d2dcbf11faf3e6fe6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb150b849b38c73353d75588d63b76edf9d1630d216eff344b8faf337e5491b2"
    sha256 cellar: :any_skip_relocation, monterey:       "1ee074ac1136a4e7891f6251c64cdb5213dbddd2692ee7a969c4042c88907b2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f598a8783e5ebd6c46cdf8ac779a1cfb44711e8686ebbe472607ba815dbf17d3"
    sha256 cellar: :any_skip_relocation, catalina:       "786477f6a740e1a93f1f77ace10b04c6ba57ed350405b71d0f2784ca1728b18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "978b8a78bc106a1f29824f9a8025ead17e971112e8a22a39aa0608527f6391df"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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

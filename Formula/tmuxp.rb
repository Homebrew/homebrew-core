class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/7a/ae/56b8199f9768f276e8c08f1ac45f7a1125582700d3cf66210c6dc09c4412/tmuxp-1.9.4.tar.gz"
  sha256 "4d7e748d58972736438b6d1299798808048e3e4649300abe6e46d285938b1b0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ff7b475365efacd1dc9c61f57b0564261ece889cbe3fe445af09e3b5bc84acf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f709a1ed9f3272f960421c29fe457e60eee14362dd34784ef958892865ad7bc1"
    sha256 cellar: :any_skip_relocation, monterey:       "a78732103dedfdd0819b6bfdbcdac297071899d7b6df43f006174ea153e4b582"
    sha256 cellar: :any_skip_relocation, big_sur:        "caa9b6af73fb4966a54d1bc6ec66fbf04a2e08ed3315f3e12f1fed76863b4ca6"
    sha256 cellar: :any_skip_relocation, catalina:       "281df5605b80eed84d1887053b4eba2ac75d7b90e916f5c679ff7d1aeeb45fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc8ef931163dd5ff0540c49a5985983405b9478bc69592f6d1a261aabc756ce1"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
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
    url "https://files.pythonhosted.org/packages/31/2f/402d67f92d129d74a6ab3d047604af5cba66ef69e462febfa28781bbd142/libtmux-0.10.3.tar.gz"
    sha256 "c7fbd837f0a9e4d33a157523e4ca6ef95e80256842e094ffd766c3dbd78d1957"
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

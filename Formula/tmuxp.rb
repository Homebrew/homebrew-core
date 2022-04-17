class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/b2/0d/d53f5ac7eac150b0292ac427813ad5c91a79b4d6fa4812cabc5d6f342c4e/tmuxp-1.10.1.tar.gz"
  sha256 "7ac9556d3a92cedf703846532e5ae8004f1c37731d686a54b046fa01f38b7c92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599a3abcf13c068ec41e722023e290077a8c603075836b709bacd51506a1f606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cccdc0c0d78f2ef82c5f0c704cbef3e414c3be0c4b546b45fbfdb49841413b4b"
    sha256 cellar: :any_skip_relocation, monterey:       "2c14cdd959720488e2ef8247d4899a957e407355e9f1cbfc55cddaa5f54ae35b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c292f62f1c460fc827b547354bf81002fbf813d28232712eb669c34e86bc624"
    sha256 cellar: :any_skip_relocation, catalina:       "454074db7beb40cce7dab128a1e1f81a599b862d7cdee3d2105328698e3131a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7cef25d7be1cf9fd2d60f1b44a9d365d3134d9a5d328f13cd7d596e9043c120"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
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

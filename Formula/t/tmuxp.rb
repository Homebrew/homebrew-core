class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/2e/5b/66ceb26459b9324bbd425c673170172066f08a6c180c8da166de6a44cf45/tmuxp-1.47.0.tar.gz"
  sha256 "1d863a08450fa5956f54af64578121c38c0693961f2154a4674faaa9fe8dcf87"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41c1493154b827680cadf4db601f8dbe009e078525bd70e73b4719c84a4f6f09"
    sha256 cellar: :any,                 arm64_ventura:  "ea5f4a155703f6fdb2b1fb435282c58acdd3c94dfa6fa31a51acb0e5d2468684"
    sha256 cellar: :any,                 arm64_monterey: "103fb60fdd32218a5e412fa5e1d126080a17c8de53a5f556e32d0ea0bcb5e40c"
    sha256 cellar: :any,                 sonoma:         "233a221828db71cad595763974d9c351ee8cd80ae6819e569ad1ebdae66dd0fb"
    sha256 cellar: :any,                 ventura:        "c0f80e9190dd778997aafaa61bb75d84468cb19bb887290d49c6e55247b76c2f"
    sha256 cellar: :any,                 monterey:       "bb617086716de2852c801a74ba7bf7a233b26f2a5496a38ae05d1883a9a886b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0cf1b16eb1e410f40c508da7b7800d38f31c38841d6c24fcfcf61eaa51f8f19"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/4a/51/b2543613a0f85247559073bc69cdca4cc0ccb590a45c98ac3400a51ba877/libtmux-0.37.0.tar.gz"
    sha256 "21955c5dce6332db41abad5e26ae8c4062ef2b9a89099bd57a36f52be1d5270f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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

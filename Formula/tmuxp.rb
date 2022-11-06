class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/5c/f7/7769dc16ca15c53ac17cf63bbef3bb72892f6ea717dfab8b0690ce62ebec/tmuxp-1.18.2.tar.gz"
  sha256 "8c1543b5b3d43e38d55de3b38ef45b9a7fe33359dfc9d6c7cab9067617ca87b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e339c1cd7a6ce2fe58754f770694daf357be89db42eec5f25813e5012db42e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3823b1ef03b3ca5c65765fed29dcbdd0e2695bc1084f5bfc5256d7323b8d23b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4096fd280f793106ccdd2a907ae5f774c6de9b9d55620fc54f13b0c6d75dfc17"
    sha256 cellar: :any_skip_relocation, monterey:       "92a54f816befe5ea52b402fe029b3ba58625b3a4cae3614dd124aea556a5d636"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdcf05012f3fabc50f1d35383e61574148f098cad24af7284be8bd47d2854b26"
    sha256 cellar: :any_skip_relocation, catalina:       "d3115060de42ff5586b0dd1b1bf0ab4e8c7f6127093db69e687f53fbab3074e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50383ba216fc7e433ef393bd6a2ae9949f796fc0824e947f3fe10f3790681623"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e6/70/95d7016b1749e3c8fa5f7cfcb054560adf815a4aa9929a0afeb994268b32/libtmux-0.15.10.tar.gz"
    sha256 "c40959c5ae9e7add705a3c4e60365667e65ab45835a9e663692e428e1d7e42e2"
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

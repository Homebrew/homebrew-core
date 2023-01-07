class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/68/39/1b82064180d75a1f739dd962c95d665757c90a2faa6c4f476c49c3a16f96/tmuxp-1.25.0.tar.gz"
  sha256 "f36bee4938fc42bcd621d91c8b7333c8454480a95f6ad6064850cecd5af01387"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e0a74b98a00d7ee854d8a7d66a5a5c4489f541f3c9a11ad0c2ac2b05e50048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2160f41d0a6e4f503aa7f2f942a19388aeaec624d754bd77d23e1849f1b117d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8a9d81b71cf2cf11f8a29d7853dadc0393a1af2b3aa42760bd41ee92f5028ab"
    sha256 cellar: :any_skip_relocation, ventura:        "11874c425f811dfe70e43114b6bbd78eb5ffe63541bfab2085a4072dff8fa3b5"
    sha256 cellar: :any_skip_relocation, monterey:       "d57a44697ac4730342639ee651621a0ea5bc180b0b9bfd0c5141116aa26ba139"
    sha256 cellar: :any_skip_relocation, big_sur:        "03ea76415dacb263345e090287f371c710b274a0a6cde1b1b911b667e9fe47f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a37c8f222df0db08c4d93f51f35c5d25927d87f9575fc70be72490c95973bee"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/02/98/3d5bb96dca3c8e2bb6a541a7b90821e2bade1457948b9c99b7a15de528a7/libtmux-0.19.1.tar.gz"
    sha256 "614fea2b09ed344735b4da2fe35e763ca2087e89a73c39d3663ed7f515fae356"
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

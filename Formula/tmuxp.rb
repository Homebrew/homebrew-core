class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/71/0a/74a52bf5333893b7a95ee4786bf4d2aab5bec6635a8bff0c72108d9ebf66/tmuxp-1.21.0.tar.gz"
  sha256 "2e421623f6f69437168a4e84b46cb698033a505e6bd97367b5c3932c669c2bf1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec07d2022f105ed1045dff30e8db36839ebf8b1b48641e579038ce2cacfc0ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6328efad8337d35cc58781147204ca6e0248733ee87b556c3f66e71ecc002b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9825c3e75afba30e715af3d23af63c690d63505a507f8b467638e56cf91f008b"
    sha256 cellar: :any_skip_relocation, ventura:        "c39c15fd58989474a5f8d31dc9dcce98f7ed0daf32c5a26ca8db7c076136e7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7d5a50d071485fb4cc713deddaf0113c373b211a8a019a12707cd05c3ac6d31a"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c28e0dd8ca644393a8eb5f1c9c962cf9463fabae4d1e779a1f9c7b426f70ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574705a720ff06fd44a5453969914ccec8fcd1bb2c7160851b126933b2c1fdb6"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/db/88/d42e629a52be35ff4774d8f154bfe1c263ab2ee37f069fa792f0423bf530/libtmux-0.18.0.tar.gz"
    sha256 "c51ccd5ef5ff18232fd56a72cadddd36bf3ad79e0dbd34cdad4a06d821a2af84"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/4a/52/d2cd0186d2b76b50ba81004629bec89809554ac782b991d6282de8eae4b7/tmuxp-1.39.0.tar.gz"
  sha256 "13c435b82577925e2b620fdbcf08e4dc235053fb8ff65119cd2a9c38590bad8d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d50edace012a1cb99737d2292f2adbc1ea4980f1fa950d6b6a693f94e6358dab"
    sha256 cellar: :any,                 arm64_ventura:  "2242bc15aa59e076145c97027d8a3c079996e2520a0651013e96308ddb4403b9"
    sha256 cellar: :any,                 arm64_monterey: "77ea8bfcae7286d5d0d7d258aff6c9700bf94004a7be5b52044fdae84537752a"
    sha256 cellar: :any,                 sonoma:         "576ac84521399e5405cd361bf1470b37ed5a0a0522370d7ee35e5fa92dc3689a"
    sha256 cellar: :any,                 ventura:        "85087b515a9a22600702af9662b08aca014c8fb76bf77e1023ee8eafbf221005"
    sha256 cellar: :any,                 monterey:       "70712d4035d416ca725a170dd8a1f64852ad0b6d2f3a3078b96be31d86780eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fafe9cf948e5f77146bf6efd78d750030a7849c28cd4051f23f1c1719b8a0e65"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/9a/d9/5da31caa48d24041c759255e10e8388c2eeb49fec30c8731f6b2a8d543ad/libtmux-0.31.0.post0.tar.gz"
    sha256 "38fd419a4e1088bbe6fffac73af00c0741b3a60e476a1fe179be746812fa717c"
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

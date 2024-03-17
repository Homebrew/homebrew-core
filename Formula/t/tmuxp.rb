class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/b3/81/225ca54607fac79c0cc26a23079080392cc8175c46be6ae34fb2360bb0e2/tmuxp-1.43.0.tar.gz"
  sha256 "49b319a4cadc38637312a6bfdb1d0eb600b6fdf84aa7c3ebb3c1eca72dc8ded0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1abb8092df13156e15287361bf9eed0e7a897fb821dfc4a158a8d3539edf30da"
    sha256 cellar: :any,                 arm64_ventura:  "d7931622af7b58c64353b5a927aa021fc881110c594b517e6466e0b80676d8eb"
    sha256 cellar: :any,                 arm64_monterey: "881ce1545cfc4c462fe021abf389cc178d65a86bcc37bfd9f5a5f264f2f6c358"
    sha256 cellar: :any,                 sonoma:         "f57d8d3a9aa2ec934a75165c46cde1eb4aa3def890023aba7612da91f3d823ae"
    sha256 cellar: :any,                 ventura:        "247671a899cf22caf4a32d2e9577c2cf67c93cfbdbdc33ddc6c31735aa109155"
    sha256 cellar: :any,                 monterey:       "d1410bcdc9dd7ee6228a78b20530090c7460eba78de3a9ca2460da6f89be1373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574981501d8aadd4f9203ce5019557690921b4cbf8d3f5a80352b9bb54b4cd4a"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/f7/18/f546631c20cd25050d8a92592ed5a562f1f99aad02b3c91bd6040dc130ed/libtmux-0.35.0.tar.gz"
    sha256 "411f6175be67d5a598e414e45a1abf14224d8c167a9d7f7fbdcdd1d1d0fefc11"
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

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c7/eb/e47052541a58dffd596f67c27505cfb2e9f8037e5ffe9a7f14f59364e641/tmuxp-1.42.0.tar.gz"
  sha256 "6fe1faca317d0e4f8393510d5bb514a76dd9484d593fff18dfe2425dbbc109c4"
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
    url "https://files.pythonhosted.org/packages/27/a2/8a722f6629b85d7eca9ce1c4fa6a71bc60e4fec8bb957c93f6b519c0074c/libtmux-0.34.0.tar.gz"
    sha256 "ba2b507956b6ff31aae3f0bb7999d521586133a02bc814245ef3b10b93d1458e"
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

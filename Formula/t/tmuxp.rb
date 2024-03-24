class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/0c/17/ddd23c02a7e31a1d94a16d338aa82f96ce67211853b84c81c7bea2980014/tmuxp-1.44.0.tar.gz"
  sha256 "3d5c1591d8ef054cc46ad33f99f7d18d24920091a8b0f659c611ac80273e7b93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33b546050f3b160cca9a29c6056472b0a4382791904e8fe0c86edce4e83dd5df"
    sha256 cellar: :any,                 arm64_ventura:  "c65360ca7f5d994e80105fee34a7c0a623b6b3e5b8260425344a88934bf1d529"
    sha256 cellar: :any,                 arm64_monterey: "544b4e4d1b8cf1795ef4bc9d451013f454de999c0b552b79626a262de0266e24"
    sha256 cellar: :any,                 sonoma:         "382dab9e6973119f28c0de6dc7993a398bde3e2335eb78f7742f8b2915e07aaf"
    sha256 cellar: :any,                 ventura:        "bbccd707bd9edfebb08751662cc9f8241c04db9406eacf768ca505abb71ce096"
    sha256 cellar: :any,                 monterey:       "33041bf349569f1156c7f92593ed45b64fc1ae66b9d674fe3c976c4867f5e571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f85a79d90248dc8ad59d061dacb9daa9bb94b9ce7f2025ba6403c50178bc5cc6"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/f3/91/921d6965e39d7c767515a0b1dce8d66948b1daf8deff629aeb5ef9cfd08f/libtmux-0.36.0.tar.gz"
    sha256 "12b5554b3a19d663d2a04f30b87fb063bd6456463a3ef6c6445a721fd7f7569a"
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

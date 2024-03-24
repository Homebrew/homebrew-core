class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/0c/17/ddd23c02a7e31a1d94a16d338aa82f96ce67211853b84c81c7bea2980014/tmuxp-1.44.0.tar.gz"
  sha256 "3d5c1591d8ef054cc46ad33f99f7d18d24920091a8b0f659c611ac80273e7b93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1565cfa14f44d0b8b42b0c3a70edcc119731f17752575916eb027ecbba453686"
    sha256 cellar: :any,                 arm64_ventura:  "aceab112430148b676414406235f8b581868b5d08a522e96d071fd3688867bc6"
    sha256 cellar: :any,                 arm64_monterey: "585d7ebf2d170f3776e2a552005e8e8e87704ad0435d8bc50fede979d1d1048b"
    sha256 cellar: :any,                 sonoma:         "73abc60cb7bb8729ec2200adb895657ed107f3f25766da6c9409107ce884a8e6"
    sha256 cellar: :any,                 ventura:        "9afd4141a42d5e415be9fda30f9577c8dc10c702a9547cff5711adfe910a05b2"
    sha256 cellar: :any,                 monterey:       "bd2832b71608ffd65e33d42ec7989a289b3c020f7e362663b4a11880567b80d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ca51c96b6ed3c4dc44a9dfb8501b3121b448ba239164399d58478931540ce7d"
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

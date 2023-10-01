class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ee/13/6452d38f37427c700cb7bf7b1e1d9aea555258c126879dea0f4560d3d917/tmuxp-1.31.0.tar.gz"
  sha256 "263977a1eea6d05ee138c232028f7ec6d4c17dea9ed8fc2eab73666ad859aa73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "495cf47a30c007f7d7466d419b26a3e241889d8a9e775e9f1c4f57b0515fda2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "754c240bdf8ffaa72525ea331f0bc75ebe0d39ef6181e35f4a3a3e8b199b8a9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d62bb14c2365027c812a550ba3eaf86efbec6074c865c4b0c08d73d1366c9837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b533d1a79a35707ac7ba3cfbce11a78bc3459a78745490cc8f26bee4113ecd22"
    sha256 cellar: :any_skip_relocation, sonoma:         "476943e24d423fd26e5a758abd4c07451aa37a4fa94248bc0b93e469b6328556"
    sha256 cellar: :any_skip_relocation, ventura:        "1f14981e50821c6d5244860eeac72e5b7e10ac1be107f4a7ca4003d115dc0a95"
    sha256 cellar: :any_skip_relocation, monterey:       "b079261df8bfa907bc4e90fe344f8c72394f5529cc68b50cb67a8ff541854330"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa0b373f7d21fcba09d274d1292b5150874d8333cffc37b472ed8c84af092c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e62d13235128ab72b39d1521f25eef21b907eff3304363df8f6277d3ea2cbec"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/21/99/5f1d5d24a1fbccb79b036bbf0d47f48d5db1a43266082eff8b5eaaf5afe6/libtmux-0.23.2.tar.gz"
    sha256 "eb3e8fb803e4e7c9ce515c93a95145aa6a0b58ddb2ae532daf9fad879609971d"
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

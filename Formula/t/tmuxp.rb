class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/d7/21/00b6fdefcb3045f372df8339f42846e37e4e57d5d27d54f4dc27c6d33742/tmuxp-1.80.0.tar.gz"
  sha256 "588df73dbe49031d2273db0aeabff5b05611fa65efd3c1ef9d130045524c38bd"
  license "MIT"

  bottle do
    manifest_sha256 "3b27af02c9d929b4c109b15a4db5a82a99a4298aef34e2cf753520839455c5cc"
    sha256 cellar: :any, arm64_golden_gate: "58b4e145799e50b5e9a88448ac55fa932f5e8d6f2df18b1908fa09641dcbc6d8"
    sha256 cellar: :any, arm64_tahoe:       "4e8fbb0164a72463a258a7e4984ce81d8e0037759155495cf0749015365d8dab"
    sha256 cellar: :any, arm64_sequoia:     "4b2b03a965a291d34b42b7bf833c09e363518abea1c02230b6ce79f1b0432c43"
    sha256 cellar: :any, arm64_linux:       "25fd7f40a7aef393dafa65b5e4f708043f50178f7a2b22d0b118f4e25bbf7588"
    sha256 cellar: :any, x86_64_linux:      "fc64b9f71feefbc4d209b9e52b571f79aec5f79b43cd8a70bcf9cc110e27fa6d"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/47/46/ddb4bed3da5adea81ea8324918ff6ec424e89a329745bf2ee5632d24a694/libtmux-0.66.0.tar.gz"
    sha256 "a973c2408e20ed67739590d43b3f6c26a0f0c1d8f70b48e4eecd910ab332881c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end

class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/d6/d4/0ca2c26e0634ed50ac3b94e8cbd8aae9a5b67f7669f4d0be0865be776cb9/tmuxp-1.29.0.tar.gz"
  sha256 "3225c6e0c573a26c9ce0b8e8bcfb2f8663e782d26ff39b3a629a3f0a6d96861a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e937e469175e808beb7a6a4579fb71e468182244fedb53155e82786fed2aade5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "646576b29bfc7360d38797127cd9d0636865bf38e1e549641ca65641f73bb5e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b27a3cd40ff6abc8f672fda866f849aaa29a52ffbba9b44a434d3341ba8b732"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac7b966595985e9aac1e237aa4780cab22caaeec6c6edae3c488d50bd44f61a"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f7e5361f8a48bffaf473c5f19ec94e51040a3813eb98fad3594ea905460c5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "505704bce5bb5af422df8ec7e4323290dd7c17f6e9db6e0c5c34e2fe34965892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c02e93f48beef08b9c4cdece99017a8dcf840ebeae96370b9e12107a1c6755"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/48/67/9a4046d26b457b68b6f03dabbd3c7dbf7fd1f169870b404e61276d9e16ef/libtmux-0.23.0.tar.gz"
    sha256 "ada1a6677076c1cae985de96ebde3d56bbff84264350c0cfd959025bd6d09010"
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

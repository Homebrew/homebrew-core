class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/a4/72/c25f9cb44747f77fb9e8892d0acb950331d5fed6b87a45f431eef10fcd00/tmuxp-1.30.0.tar.gz"
  sha256 "4e4ac1f2f389a01c859e6d6c690e60513a028ff29d9cc4d73354bdaf9514a4d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b08d5cfb7defe5147f5e93777b9da4a68fefc82f1f1b884cb268cbd6738dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7ac7fc5bec4cf005370e3b1036c9ecee1258db759ce65a36123b9c54885ccc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cae2daeb1be8a66950bbbd2c294b114ff0725a9890cdc57963e1dcf749fc98a7"
    sha256 cellar: :any_skip_relocation, ventura:        "e478d25ef8bcaff3adb9bd71bdb82a004aadd15446d599ce0c6fbb6b87047208"
    sha256 cellar: :any_skip_relocation, monterey:       "9e369576071f0b78b5048da9d9eaf8f173811b5ade54f325a9794e7e5927cd6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a461c740cb74abfd78418a2bb5cfd75e2f1354d72776607542693b3f563a34a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d66820788e2122fc59c8c428cc594ea574a502332960fd28bc400f5817554d"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/7f/d8/8a4ed64d5b51aa2cf411d5fd25d7881d685b647f4416a2bf47943123ba02/libtmux-0.23.1.tar.gz"
    sha256 "398973268782376de8962ebe205c6b9601d3580f6541c6a1dd5e43f8c7e2dd82"
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

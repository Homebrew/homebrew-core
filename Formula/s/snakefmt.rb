class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/40/bd/86b3e22ada4ced9529739b6ec7004c3f5b3cadf31c83bb4ce3e9650b5a2e/snakefmt-0.8.5.tar.gz"
  sha256 "5aa5182dbbbeb84d477dd0f5a9eeeba41bac1f185cfd4897a0b005d4af59ba71"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e8d9b840fd280e35b5ab8d21fd0f5c3fa20d30c0955d8e6cc011f1baf39f0a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbd5ee3e29200c87c548b25c24ae241b65ae82e0e558f43b2f643c04d0d11e02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5906a25bb2dff36ec64b2586720fbca3910fef3878d0bb8fd2b4a8b912ce40f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1705fa2e6de9b030120c35efd5bdc70ed458a34cfb5b034a59913c7109317ea3"
    sha256 cellar: :any_skip_relocation, ventura:        "df96b25cc3bb72b5f3fc8bd209cf66a169728d991726621238037ef7a67d99f1"
    sha256 cellar: :any_skip_relocation, monterey:       "1b25b83483830c3ac009992898d1762bb4721210259df86a2e88b4efd2e10a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebbafbdd6b2d1418f3c4e8ce1ce8cf905206c263be4ddcc8ce845650b0028b3"
  end

  depends_on "black"
  depends_on "python-toml"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    black = Formula["black"].opt_libexec
    (libexec/site_packages/"homebrew-black.pth").write black/site_packages
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end

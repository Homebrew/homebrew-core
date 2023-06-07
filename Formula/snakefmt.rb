class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/36/9c/00be291ff608ca73cbc9662c1c59cddef20279298e0fb410ca1ec1875c99/snakefmt-0.8.4.tar.gz"
  sha256 "277eb436d4d61161d2c75c6eece44df34bcbb6299bc3f4fffafb0976e16afe40"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aacdd85f47b9d06f40d5f6914c9d75aca441a4e4e7035847c6e2ffa3501e4a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c515b72d75101adb1c0219312e3f0ac252556e49578f061162a95c36754e2cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d336d69b89cbed603f00c61c2da20b450977e74ad2a4bd033e301bde8760f39"
    sha256 cellar: :any_skip_relocation, ventura:        "59752e99382174eb8cce0baba33d460ac69c9f569d0bb78fa64ffd08e877d10e"
    sha256 cellar: :any_skip_relocation, monterey:       "91b6459f98238ef9a08c5706ca6750064a900209c022cdeb83e18cc4f07046a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98ed4fb2bccfd8361905ead0c3b42768bddcd502fd1a123a8056df621fe4828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96caa291d8fe76b796a11ed33d6b9bd8264ecd9612cbdedbf00c7fee7feccb05"
  end

  depends_on "cmake" => :build
  depends_on "black"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

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

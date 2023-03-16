class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/b8/c5/a8045ae37914c99f134fa05abfd2c1b47bd2cd08a10d294a45537c22a588/snakefmt-0.8.3.tar.gz"
  sha256 "df31a9257e9670c9bef0d3efc22264f5ee7fa3e91dd9e062e97864c69c226258"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3560bd04ea43ae69c0a65fde79b34db45cef009ecc4931c43b3e6067a95c2ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9c6e7a75213e4914a1ec62ec761307ca7da0be0e38faf14577bd392336368c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59ada6a2066cf380efbc45966a4935fbf537ee18104d96cbc2a33f662c0372d4"
    sha256 cellar: :any_skip_relocation, ventura:        "89232936aa85ec0a2779e832244abf3a77ef6f746401c2d4694e3b88401770ad"
    sha256 cellar: :any_skip_relocation, monterey:       "762c97a6973a429e9584614fc41ed500d1beadb5e27563546040a654b2ec4428"
    sha256 cellar: :any_skip_relocation, big_sur:        "7561d6646f00fb43c513e09b9ecc7cc01968b032f4cd6698492855d5321098a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a61f777d58ba6b2082a4e459d4a77e71efa79322e19c97c2067e5e3edb442cb"
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

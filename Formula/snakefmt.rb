class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/b8/c5/a8045ae37914c99f134fa05abfd2c1b47bd2cd08a10d294a45537c22a588/snakefmt-0.8.3.tar.gz"
  sha256 "df31a9257e9670c9bef0d3efc22264f5ee7fa3e91dd9e062e97864c69c226258"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e96a2d41997698e3c1c89ffb37eb11694f528960b49798dec95046fccc52896d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3f3032bb5686a7584d4e9db7bf4f180e14c11da4acdad729b6c271c5386ca1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16cf32beb7a2886e60dd6f87728b2fa67d8199b19d3f2442b41dd02d08359861"
    sha256 cellar: :any_skip_relocation, ventura:        "705c3c725a8b4160ad0ef02efb3f033c62ea290a0c5e0513235f29f5cf3b644c"
    sha256 cellar: :any_skip_relocation, monterey:       "2d511bc2cd2eae9722940499b3c037d3e70820e2484ae5dadb17edf47f318eeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8829ea81a3ad06d32f92d13c661616337a4da6f0376df5c51cb740799a3dedb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48cedf117e7cc1e391f5f156f31183c4e0d536a668f3b47b8ca71ccf3e4b2a31"
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

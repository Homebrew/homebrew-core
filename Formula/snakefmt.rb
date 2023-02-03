class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/dd/2a/7e2bf9b7e61c23b39d15fbb4b5ea0e48c5ebca15be54b9887810621b24ef/snakefmt-0.8.1.tar.gz"
  sha256 "73158bf48645603ead6f0aacbfe4f43cf8dc0fbd192fbac813a3e64baaee995f"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aa93c2a19c0bab0243b6437c3310e8ecbc93db8b87203affc2954679e22c3ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "951819e2d2a50962ab7b478f611d9c35403e3cd017816e51d2dc5873c38cbabc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cf8eeed7dd532c9e7ca96c85be349ca08cb8c5704ca98899438aada619893ca"
    sha256 cellar: :any_skip_relocation, ventura:        "a71f0ec41e979fa968fe3794da34c8c8bbf93dbd218e1ba65a06b2ef06980f66"
    sha256 cellar: :any_skip_relocation, monterey:       "50712fd7fc8b1f6ab0e584f04c7434caa18227e104a67f74ee9df454e8d9e67a"
    sha256 cellar: :any_skip_relocation, big_sur:        "08b849820345b62863fd4c59e2b8cb51e5ea89d8a702938af6794f12f861e6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4636514398d8a3023e7f3db67c02daee1b4e04b3a413d68d8e02e1ef620dca8b"
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

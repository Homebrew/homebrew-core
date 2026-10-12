class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/da/9b/c3dce69468a32d9b2dd9366c41c472b59ecafa28971761e8620466fb288f/snakefmt-2.0.3.tar.gz"
  sha256 "1aecfed46d631eaae8179e4bedd09450c8c306d221cfd4b3594e35a8dccd0618"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c78388ddae56f5de766544e2d6a7de4550e3d685c2f3885e6c9542be4617e5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd946af9a59c83626ac7853000173f2c4cde885150fa97bd64dd07c568daf02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34f75c44e906383165fc9ab77b6ee7b89ac225d645e1d312452531f40aec135b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "de18c359cbd2e9698f571acb1b59ea132dca7554a2d0657fbe853f8346f988ce"
    sha256 cellar: :any_skip_relocation, sonoma:            "b9264f3424e3dc5d2f7293bda329a865dbc8141aa4e9dc844704f12e6360251b"
    sha256 cellar: :any,                 arm64_linux:       "c95c7ebbeabc84cc79f15c656f5392f6b41eba98e0452fa885d69e41e64c11ac"
    sha256 cellar: :any,                 x86_64_linux:      "a295296c9db66ce5aa4fef29428e231b7bc4ff7d020442c6a186d3cb90f3bc15"
  end

  depends_on "rust" => :build # pytokens -> mypy -> ast-serialize
  depends_on "python@3.15"

  resource "black" do
    url "https://files.pythonhosted.org/packages/f8/65/a9611a6ec0a8c88d86e59385da02d68d9533f7e86a05913d20c67be54029/black-26.10.1.tar.gz"
    sha256 "5f9f83beae62437e060dafd53d7f1fc327e3d3494f74d72ee5c2b73eb90fc4e7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "shfmt-py" do
    url "https://files.pythonhosted.org/packages/ee/91/0ae8bbc703ac6779427fcdb40da7784b844278032f7896dbe54cb7e11e0e/shfmt_py-4.2.0.tar.gz"
    sha256 "cf7842d69e9f787ce97503c1280e65417f2c08014d594018dda245fcba96ff51"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"snakefmt", shell_parameter_format: :click)
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

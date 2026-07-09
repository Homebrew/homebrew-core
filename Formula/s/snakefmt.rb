class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/da/9b/c3dce69468a32d9b2dd9366c41c472b59ecafa28971761e8620466fb288f/snakefmt-2.0.3.tar.gz"
  sha256 "1aecfed46d631eaae8179e4bedd09450c8c306d221cfd4b3594e35a8dccd0618"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd946af9a59c83626ac7853000173f2c4cde885150fa97bd64dd07c568daf02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f75c44e906383165fc9ab77b6ee7b89ac225d645e1d312452531f40aec135b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de18c359cbd2e9698f571acb1b59ea132dca7554a2d0657fbe853f8346f988ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9264f3424e3dc5d2f7293bda329a865dbc8141aa4e9dc844704f12e6360251b"
    sha256 cellar: :any,                 arm64_linux:   "c95c7ebbeabc84cc79f15c656f5392f6b41eba98e0452fa885d69e41e64c11ac"
    sha256 cellar: :any,                 x86_64_linux:  "a295296c9db66ce5aa4fef29428e231b7bc4ff7d020442c6a186d3cb90f3bc15"
  end

  depends_on "rust" => :build # pytokens -> mypy -> ast-serialize
  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "shfmt-py" do
    url "https://files.pythonhosted.org/packages/06/d5/c2ad5c6593a34da7344cf39bde65763e8cda752589074ba1619e55b317ad/shfmt_py-4.0.0.tar.gz"
    sha256 "1e5fdacf40aabaa77a97639d52a6220df0893b46658d82b7f136f4e66e2b2fb0"
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

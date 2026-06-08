class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/87/6d/d14bcae72c0b2c43b3a956e3690e5a27a2e659723ecc4af684b7be339d13/snakefmt-2.0.1.tar.gz"
  sha256 "d535e3a0d149111a1e8d66ae8a78a506aff7a648137a619a36fe7c8946a02476"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da59507d24dd0b6c8043d609f4bdb68564dcc4653bce8949875e13f0294b8e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c1cbac63490339960a15d798764f92da68305e85c42cda725f946a1b4340dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12590cdbe701e27a3829d4aac37ad8d6f0fa812880161ff4a3a6cc00c78963a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "017c67f5994e6f13a45a318293db4285596a8dc7bab2bc5cba95123d9014ed22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9ce7cb695e3b35e1dc0103993043b3a6e0c200c793f3e2e4dc79f5ba54fe6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11901315717e027e8ea326bc91f9b0c044630d09f4750da9fa17d82553ee9216"
  end

  depends_on "rust" => :build # pytokens -> mypy -> ast-serialize
  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
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
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
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

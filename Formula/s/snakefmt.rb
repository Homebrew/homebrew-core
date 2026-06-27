class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/1a/40/6c05d546237a73be5e80434682534337854fb7556713447c1c31236ba14c/snakefmt-2.0.2.tar.gz"
  sha256 "aa037ff2579fcdb76f4d5b722b3438738fff05924d43faf4655ff7eebd64152a"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2d04f6400a75f8aefe4ed3decc2f6b3f5662c5f043e1b43c9a37a40e76a1525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9025c9469a9e962d3297b1511606f3efadd0cae60ac5f5cec0dd79d6012bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b3453a9cc96d0124b9e5af17a3c5ae2882b3e0e845960d2ad7217378132445"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd6ad9d59c2f17abc2ad297ee106e459a50f7121a443d02c1925ca10b651d17a"
    sha256 cellar: :any,                 arm64_linux:   "7199ac2cedc8823f504f6d5fdd49d21a71f597553f000a6d80352344e0fdfa48"
    sha256 cellar: :any,                 x86_64_linux:  "17e52de697c0f22da12f432e877a83b181a28f87ac815c022a547858e5aa43b9"
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

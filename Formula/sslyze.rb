class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/2.1.4.tar.gz"
    sha256 "817b37f49f179ecc5dbd663ad256e626865513192f3ece54181eee4a786f02c0"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/2.2.0.tar.gz"
      sha256 "3a6abdc6e4510c4f6f8921cf57feb68781074416eaad3920cb35f3c03232b82d"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "75cedd2004b9268d5abac35bf71be4205955221a6dc9aeeee65fc934cffe7b0f" => :mojave
    sha256 "c84dcbe2c30a40bfcd36cafc7418c8842435bf81aa9bbd82a18286892d76b3a5" => :high_sierra
    sha256 "f65561a05b88c4561c00c024fcecd1def2f5ba65a92875255342ca601732a38f" => :sierra
    sha256 "ce82f4e5b63f2893b81f9d95cea808cb340a973fab0a0510346cd4a4156190a1" => :el_capitan
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on "pipenv" => :build
  depends_on :arch => :x86_64
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/c1/a9/86bfedaf41ca590747b4c9075bc470d0b2ec44fb5db5d378bc61447b3b6b/asn1crypto-1.2.0.tar.gz"
    sha256 "87620880a477123e01177a1f73d0f327210b43a3cdbd714efcd2fa49a8d7b384"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/69/ed/5e97b7f54237a9e4e6291b6e52173372b7fa45ca730d36ea90b790c0059a/cryptography-2.5.tar.gz"
    sha256 "4946b67235b9d2ea7d31307be9d5ad5959d6c4a8f98f900157b47abddf698401"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/49/c4/aa379256eb83469154c671b700b3edb42ae781044a4cd40ae92bff8259c7/tls_parser-1.2.1.tar.gz"
    sha256 "869ad3c8a45e73bcbb3bf0dd094f0345675c830e851576f42585af1a60c2b0e5"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    res = resources.map(&:name).to_set
    res -= %w[nassl]

    res.each do |r|
      venv.pip_install resource(r)
    end

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      system "pipenv", "install", "--dev"
      system "pipenv", "run", "invoke", "build.all"
      venv.pip_install nassl_path
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
    assert_no_match /exception/, shell_output("#{bin}/sslyze --certinfo letsencrypt.org")
  end
end

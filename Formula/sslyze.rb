class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/55/9e/a502a3adb05a1d483b6f9e3332d8d8b2b5984eebe3f7411a85bc2d74c146/sslyze-5.0.0.tar.gz"
    sha256 "986c42bf3fee651e2f66793a5fc0c78774e979a770e0634140c5cc4d9a453b27"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.1.tar.gz"
      sha256 "22675489317eea24155c4579da8ec89c87628887132457da5973218edad82e9c"
    end
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "502cc4dbd5025f1f4ad8ddf2c1a078a3018b9d65bfc9e780e68a8d1622c18e9b"
    sha256 cellar: :any,                 big_sur:      "e8097ebd7ba96d86cdd3eb25ebdbab97430f51954d67ce98c1e46fae7af2c629"
    sha256 cellar: :any,                 catalina:     "ab656f1c81d3d2b9796a28b8d23ededa007a36465c057bec413242e551d4bc89"
    sha256 cellar: :any,                 mojave:       "d1dc50bdb9dae7fea7bc68867a449398e9caf4549fb0a087769f987154a5c660"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a339aa801665f3e3a86ff458b9ebc1ee4368cf41d8d1a73b5f66ecf48692d9c"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on "pipenv" => :build
  depends_on "rust" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b9/d2/12a808613937a6b98cd50d6467352f01322dc0d8ca9fb5b94441625d6684/pydantic-1.8.2.tar.gz"
    sha256 "26464e57ccaafe72b7ad156fdaa4e9b9ef051f69e175dbbb463283000c05ab7b"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/66/4e/da7f727a76bd9abee46f4035dbd7a4711cde408f286dae00c7a1f9dd9cbb/tls_parser-1.2.2.tar.gz"
    sha256 "83e4cb15b88b00fad1a856ff54731cc095c7e4f1ff90d09eaa24a5f48854da93"
  end

  def install
    venv = virtualenv_create(libexec, "python3.9")

    res = resources.map(&:name).to_set
    res -= %w[nassl]

    res.each do |r|
      venv.pip_install resource(r)
    end

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      inreplace "Pipfile", 'python_version = "3.7"', 'python_version = "3.9"'
      system "pipenv", "install", "--dev"
      system "pipenv", "run", "invoke", "build.all"
      venv.pip_install nassl_path
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end

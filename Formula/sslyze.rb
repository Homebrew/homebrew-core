class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"
  revision 1

  stable do
    url "https://files.pythonhosted.org/packages/d5/b9/195ada85f8577e5b99a45338974e6de2d81aabeccee303fe66e455e91125/sslyze-4.1.0.tar.gz"
    sha256 "76a50297aa2e3f4d8e2660865ca648eff672b0a5967fa052bb26b8b05e0d3ff9"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.0.tar.gz"
      sha256 "b8a00062bf4cc7cf4fd09600d0a6845840833a8d3c593c0e615d36abac74f36e"
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
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
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

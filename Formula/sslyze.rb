class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/3.0.8.tar.gz"
    sha256 "9a4d2354a0db53a70a4329e63af9ecc4639c74f9048811c2a3f03a41695c3cbe"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/3.0.0.tar.gz"
      sha256 "d340c176e497d8cf0a9233d36905195aec7d0ae9eabd9c837de8e0ad19019921"
    end
  end

  bottle do
    cellar :any
    sha256 "b5a0b1691a0f599ba5e43e54c690ebcdcb71460363e837a4c37bf7a92d8210e6" => :catalina
    sha256 "2b13136ca39b259fe1cf169f2fa0032ea554f0973b228e710c10b4fe15340bcf" => :mojave
    sha256 "60928584ee62129c4ec2ef9bd3387ed0f0d08ec7b41d10b211fe54b47b4ba8a4" => :high_sierra
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on "pipenv" => :build
  depends_on arch: :x86_64
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9d/0a/d7060601834b1a0a84845d6ae2cd59be077aafa2133455062e47c9733024/cryptography-2.9.tar.gz"
    sha256 "0cacd3ef5c604b8e5f59bf2582c076c98a37fe206b31430d0cd08138aff0986e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/66/4e/da7f727a76bd9abee46f4035dbd7a4711cde408f286dae00c7a1f9dd9cbb/tls_parser-1.2.2.tar.gz"
    sha256 "83e4cb15b88b00fad1a856ff54731cc095c7e4f1ff90d09eaa24a5f48854da93"
  end

  def install
    venv = virtualenv_create(libexec, "python3.8")

    res = resources.map(&:name).to_set
    res -= %w[nassl]

    res.each do |r|
      venv.pip_install resource(r)
    end

    resource("nassl").stage do
      nassl_path = Pathname.pwd
      inreplace "Pipfile", 'python_version = "3.7"', 'python_version = "3.8"'
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

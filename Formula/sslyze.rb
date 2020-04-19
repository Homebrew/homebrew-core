class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/3.0.2.tar.gz"
    sha256 "64baff0ffba8e89e848bd8d021268bf2e594e3417a1044a90203d44261e57fe0"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/3.0.0.tar.gz"
      sha256 "d340c176e497d8cf0a9233d36905195aec7d0ae9eabd9c837de8e0ad19019921"
    end
  end

  bottle do
    cellar :any
    sha256 "786ff8ecc969df813b0c786fc253a03c5b9d50130e2e9ce1c198f97b029d4822" => :catalina
    sha256 "a857aed8cb7c574270eb62be81d4ab39cc98485fece4a3735a4915d20c600c7f" => :mojave
    sha256 "c720d19b991842fd9c63a998c2aa55952c6c66142a7e84cc00d283b6827e2de7" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/9f/3d/8beae739ed8c1c8f00ceac0ab6b0e97299b42da869e24cf82851b27a9123/asn1crypto-1.3.0.tar.gz"
    sha256 "5a215cb8dc12f892244e3a113fe05397ee23c5c4ca7a69cd6e69811755efc42d"
  end

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
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/49/c4/aa379256eb83469154c671b700b3edb42ae781044a4cd40ae92bff8259c7/tls_parser-1.2.1.tar.gz"
    sha256 "869ad3c8a45e73bcbb3bf0dd094f0345675c830e851576f42585af1a60c2b0e5"
  end

  resource "typing_extensions" do
    url "https://files.pythonhosted.org/packages/6a/28/d32852f2af6b5ead85d396249d5bdf450833f3a69896d76eb480d9c5e406/typing_extensions-3.7.4.2.tar.gz"
    sha256 "79ee589a3caca649a9bfd2a8de4709837400dfa00b6cc81962a1e6a1815969ae"
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

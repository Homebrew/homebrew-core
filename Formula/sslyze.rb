class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/f8/2f/8afebdb46e95abff793488683b038c8d159d6e035992652febd1642d7e46/sslyze-4.0.3.tar.gz"
    sha256 "b6f74d087861a82e647507d2055d7be70810a9cff5e38c281240ca974566f78f"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.0.tar.gz"
      sha256 "b8a00062bf4cc7cf4fd09600d0a6845840833a8d3c593c0e615d36abac74f36e"
    end
  end

  bottle do
    sha256 cellar: :any, big_sur:  "9dc44847b5e2bbf4ca3fb2582470161d4d10edc6ffb86efdcad215617bc5a20c"
    sha256 cellar: :any, catalina: "cc7af9d762696aeafd91455d7852e5ed5b2186c5fe68eadec957bee4b993123c"
    sha256 cellar: :any, mojave:   "b14cdf4a1b9236db58cc707cb408dab14add2ca81daf9410942099151687a318"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end
  end

  depends_on "pipenv" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d4/85/38715448253404186029c575d559879912eb8a1c5d16ad9f25d35f7c4f4c/cryptography-3.3.2.tar.gz"
    sha256 "5a60d3780149e13b7a6ff7ad6526b38846354d11a15e21068e57073e29e19bed"
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
    assert_no_match /exception/, shell_output("#{bin}/sslyze --certinfo letsencrypt.org")
  end
end

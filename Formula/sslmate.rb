require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang
  include Language::Python::Virtualenv

  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.9.1.tar.gz"
  sha256 "179b331a7d5c6f0ed1de51cca1c33b6acd514bfb9a06a282b2f3b103ead70ce7"
  license "MIT"

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c7157d098fdb4f25cc862cf832c004a2c7e753a3f3301302707f5e64359dafa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c7157d098fdb4f25cc862cf832c004a2c7e753a3f3301302707f5e64359dafa"
    sha256 cellar: :any_skip_relocation, monterey:       "7b80bafa52a6f8070897b25e3cc876c5c58006efe7c1e819aff898e91adf0f97"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b80bafa52a6f8070897b25e3cc876c5c58006efe7c1e819aff898e91adf0f97"
    sha256 cellar: :any_skip_relocation, catalina:       "7b80bafa52a6f8070897b25e3cc876c5c58006efe7c1e819aff898e91adf0f97"
    sha256 cellar: :any_skip_relocation, mojave:         "7b80bafa52a6f8070897b25e3cc876c5c58006efe7c1e819aff898e91adf0f97"
  end

  depends_on "python@3.10"

  uses_from_macos "perl"

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("boto")

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    env = { PERL5LIB: ENV["PERL5LIB"] }
    env[:PYTHONPATH] = ENV["PYTHONPATH"]
    bin.env_script_all_files(libexec/"bin", env)

    rewrite_shebang detected_perl_shebang, libexec/"bin/sslmate"
  end

  test do
    system "#{bin}/sslmate", "req", "www.example.com"
    # Make sure well-formed files were generated:
    system "openssl", "rsa", "-in", "www.example.com.key", "-noout"
    system "openssl", "req", "-in", "www.example.com.csr", "-noout"
    # The version command tests the HTTP client:
    system "#{bin}/sslmate", "version"
  end
end

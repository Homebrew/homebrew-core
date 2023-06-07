require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang
  include Language::Python::Virtualenv

  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.9.1.tar.gz"
  sha256 "179b331a7d5c6f0ed1de51cca1c33b6acd514bfb9a06a282b2f3b103ead70ce7"
  license "MIT"
  revision 1

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d082114fb209257176956b1aebdad10478fc597de6604a5d9999e1c432e8e793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d082114fb209257176956b1aebdad10478fc597de6604a5d9999e1c432e8e793"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d082114fb209257176956b1aebdad10478fc597de6604a5d9999e1c432e8e793"
    sha256 cellar: :any_skip_relocation, ventura:        "ffcccf2b3dfba7bb454eec781fdda76a8e15ee958d3631c5cf5e2c0401bf30c2"
    sha256 cellar: :any_skip_relocation, monterey:       "ffcccf2b3dfba7bb454eec781fdda76a8e15ee958d3631c5cf5e2c0401bf30c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffcccf2b3dfba7bb454eec781fdda76a8e15ee958d3631c5cf5e2c0401bf30c2"
    sha256 cellar: :any_skip_relocation, catalina:       "ffcccf2b3dfba7bb454eec781fdda76a8e15ee958d3631c5cf5e2c0401bf30c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8cf9d5a489518810246c59334f5f0b2855888075b421698746f08391d965eb7"
  end

  depends_on "python@3.11"

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.10.tar.gz"
      sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resource("boto")

    resources.each do |r|
      next if r.name == "boto"

      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/vendor"
        system "make"
        system "make", "install"
      end
    end

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

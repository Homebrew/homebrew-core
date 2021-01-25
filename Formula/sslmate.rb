require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang

  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.7.1.tar.gz"
  sha256 "454e19338910363189b349cfe3477351a20c34c6fda0f312ad143b1688faa6c4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "61d7abbfa341a9d07f7c8b3f078d24f3b951e9d0093b57e662ef92c5d30767ae" => :big_sur
    sha256 "98c1d69f485322c03fb5edab0ecdba7a358386093cd4656985fc95ac5c956540" => :arm64_big_sur
    sha256 "91ed7cfa14d48f01dae1c4d5d672ee43a0b3e769b938a1a6d53d8e2ba31df379" => :catalina
    sha256 "39507ab1185187781a82869d1604f24f75cee165c64671ce7d003fac75e343db" => :mojave
    sha256 "5833c9efa844a9ba89f435581700186842dd484aed4a3f9e62bb92199e1ae906" => :high_sierra
  end

  depends_on "python@3.9"

  uses_from_macos "perl"

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("boto").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor")
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

require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang

  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.7.1.tar.gz"
  sha256 "454e19338910363189b349cfe3477351a20c34c6fda0f312ad143b1688faa6c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "675270c9a7dd6ed26c528153b3bb96d85928b4f9bf0eac45aa66a431b251e6fe" => :catalina
    sha256 "7c8c3adbd6de365695d82dea6c27182c2032ebd0a09d08d4a5e20cce91abc029" => :mojave
    sha256 "fd6edadfa6af0d2a2bb7390ac37b588a3c1970678e0bfcb306958902e4aea4e5" => :high_sierra
    sha256 "fd6edadfa6af0d2a2bb7390ac37b588a3c1970678e0bfcb306958902e4aea4e5" => :sierra
  end

  depends_on "python@3.8"

  uses_from_macos "perl"

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("boto").stage do
      system python3, *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    env = { :PERL5LIB => ENV["PERL5LIB"] }
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

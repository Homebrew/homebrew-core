class Sslmate < Formula
  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.7.0.tar.gz"
  sha256 "55d273bd3983aee1b88a8b7ca6f31281dbe369eb9f46c7fcba11de5dfcbe176e"

  bottle do
    cellar :any_skip_relocation
    sha256 "675270c9a7dd6ed26c528153b3bb96d85928b4f9bf0eac45aa66a431b251e6fe" => :catalina
    sha256 "7c8c3adbd6de365695d82dea6c27182c2032ebd0a09d08d4a5e20cce91abc029" => :mojave
    sha256 "fd6edadfa6af0d2a2bb7390ac37b588a3c1970678e0bfcb306958902e4aea4e5" => :high_sierra
    sha256 "fd6edadfa6af0d2a2bb7390ac37b588a3c1970678e0bfcb306958902e4aea4e5" => :sierra
  end

  depends_on "python"

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("boto").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    env = { :PERL5LIB => ENV["PERL5LIB"] }
    env[:PYTHONPATH] = ENV["PYTHONPATH"]
    bin.env_script_all_files(libexec/"bin", env)

    # Fix failure when Homebrew perl is selected at runtime
    inreplace libexec/"bin/sslmate",
      "#!/usr/bin/env perl", "#!/usr/bin/perl"
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

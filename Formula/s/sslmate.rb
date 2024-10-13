require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang

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
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "24aa12ced1cf885ba948fd57dfecab21141366667d3bc97a0c092c8dfa3e9a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c52eea8ffcdd759de0bb3cb1d6cd8d540b7b7923e13c1fec0a41c8bddb1f6f1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c52eea8ffcdd759de0bb3cb1d6cd8d540b7b7923e13c1fec0a41c8bddb1f6f1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52eea8ffcdd759de0bb3cb1d6cd8d540b7b7923e13c1fec0a41c8bddb1f6f1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1099c1cd94fa37d7eba861e8b1ef68b3bdf13f6d5750c6d15e82736e7333109c"
    sha256 cellar: :any_skip_relocation, ventura:        "1099c1cd94fa37d7eba861e8b1ef68b3bdf13f6d5750c6d15e82736e7333109c"
    sha256 cellar: :any_skip_relocation, monterey:       "1099c1cd94fa37d7eba861e8b1ef68b3bdf13f6d5750c6d15e82736e7333109c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ec200b4bec7150dba1b0d590dabee471de7683ccf7281e9612ca549a8edd7c"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.21.tar.gz"
      sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/vendor"
        system "make"
        system "make", "install"
      end
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
    rewrite_shebang detected_perl_shebang, libexec/"bin/sslmate"
  end

  test do
    system bin/"sslmate", "req", "www.example.com"
    # Make sure well-formed files were generated:
    system "openssl", "rsa", "-in", "www.example.com.key", "-noout"
    system "openssl", "req", "-in", "www.example.com.csr", "-noout"
    # The version command tests the HTTP client:
    system bin/"sslmate", "version"
  end
end

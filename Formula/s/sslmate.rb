class Sslmate < Formula
  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.9.1.tar.gz"
  sha256 "179b331a7d5c6f0ed1de51cca1c33b6acd514bfb9a06a282b2f3b103ead70ce7"
  license "MIT"
  revision 3

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ab2aaac709b5ceb82a209942838750de64729f4aceebea3ce0dcc7874a3b2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0ab2aaac709b5ceb82a209942838750de64729f4aceebea3ce0dcc7874a3b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0ab2aaac709b5ceb82a209942838750de64729f4aceebea3ce0dcc7874a3b2d"
    sha256 cellar: :any_skip_relocation, tahoe:         "d0ab2aaac709b5ceb82a209942838750de64729f4aceebea3ce0dcc7874a3b2d"
    sha256 cellar: :any_skip_relocation, sequoia:       "d0ab2aaac709b5ceb82a209942838750de64729f4aceebea3ce0dcc7874a3b2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ab2aaac709b5ceb82a209942838750de64729f4aceebea3ce0dcc7874a3b2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3bdbdeca9bd38aa4c2b587b7fadd710978a2d12b20c814b8f463817cce90eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33c4fb02cd4543853b119533923a62e80f5690e23e42272b94c6a467c880320"
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
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/vendor"
          system "make"
          system "make", "install"
        end
      end
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?
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

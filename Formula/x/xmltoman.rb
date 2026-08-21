require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, tahoe:         "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, sequoia:       "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, sonoma:        "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any,                 arm64_linux:   "bd5e21010f569948d6da34986ff3881e2befdacedd5c755005b0caa8b4ac4a3e"
    sha256 cellar: :any,                 x86_64_linux:  "13c53ad2a94fa4249c146a7d34a0b3127be4696b8f56dbd0f86aecc1671fb1cd"
  end

  uses_from_macos "expat"
  uses_from_macos "perl"

  resource "XML::Parser" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end

      inreplace "xmltoman", "#!/usr/bin/perl -w", "#!/usr/bin/env perl"
      rewrite_shebang detected_perl_shebang, "xmlmantohtml"
    end

    # generate the man files from their original XML sources
    system "./xmltoman xml/xmltoman.1.xml > xmltoman.1"
    system "./xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1"

    man1.install %w[xmltoman.1 xmlmantohtml.1]
    bin.install %w[xmltoman xmlmantohtml]
    pkgshare.install %w[xmltoman.xsl xmltoman.dtd xmltoman.css]

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?
  end

  test do
    assert_match "You need to specify a file to parse", shell_output("#{bin}/xmltoman 2>&1", 1).strip
  end
end

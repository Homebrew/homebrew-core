require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dc66e4edcf9738b149ab2d52a0b50185d94237f473a174c8a3b40a747149f8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dc66e4edcf9738b149ab2d52a0b50185d94237f473a174c8a3b40a747149f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc66e4edcf9738b149ab2d52a0b50185d94237f473a174c8a3b40a747149f8a"
    sha256 cellar: :any_skip_relocation, tahoe:         "1dc66e4edcf9738b149ab2d52a0b50185d94237f473a174c8a3b40a747149f8a"
    sha256 cellar: :any_skip_relocation, sequoia:       "1dc66e4edcf9738b149ab2d52a0b50185d94237f473a174c8a3b40a747149f8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dc66e4edcf9738b149ab2d52a0b50185d94237f473a174c8a3b40a747149f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820c90d12578e4a1bb4276c03e5acbd0a03d9f0b0317de2b4b1d0c731878a60e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df54ca9aec96466a2d111f21e4fee9fae3b96ade496f0801b2d0bf51ead733d2"
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

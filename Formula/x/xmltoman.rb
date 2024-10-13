require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bd5bd5e45226df0b0e79d4dac5ef271731c96f568d275d2c4f903d9139c477b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27b72d91e8bd4c48a82d2328598b1de5d21049cff8cf9d7466df9da57378110b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27b72d91e8bd4c48a82d2328598b1de5d21049cff8cf9d7466df9da57378110b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27b72d91e8bd4c48a82d2328598b1de5d21049cff8cf9d7466df9da57378110b"
    sha256 cellar: :any_skip_relocation, sonoma:         "38bd2ebadf4eef66896118cda5ee50038f94630e1d3da2ca4253e151bae7fc9b"
    sha256 cellar: :any_skip_relocation, ventura:        "38bd2ebadf4eef66896118cda5ee50038f94630e1d3da2ca4253e151bae7fc9b"
    sha256 cellar: :any_skip_relocation, monterey:       "38bd2ebadf4eef66896118cda5ee50038f94630e1d3da2ca4253e151bae7fc9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5690e906d64cedbdd8f98ba039f638dabac00067996ac5a95c0cb8d19702c8b"
  end

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

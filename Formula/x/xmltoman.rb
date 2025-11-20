require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31d84ea84ef79d74cd713bcbcfae3b30ed1ad0b1ea82c1a76e6f76be9fba5827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89d762e0509fc153a86b20d8071f20b86514f079eed038ae78c44bf47d33c53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d762e0509fc153a86b20d8071f20b86514f079eed038ae78c44bf47d33c53b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89d762e0509fc153a86b20d8071f20b86514f079eed038ae78c44bf47d33c53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "50221d09be7e7840727a931f8d771b2ee35c587870a070ac0b71115ac8636eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "50221d09be7e7840727a931f8d771b2ee35c587870a070ac0b71115ac8636eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60ce2ada67d84c2b37d2e48ef5ca6ef0c51116194f4d10cea80d4210dba84d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f936fff8828e2d4766a273f91521c76e87e3895d43d0a8cc823a18b214f910"
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

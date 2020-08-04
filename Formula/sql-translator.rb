require "language/perl"

class SqlTranslator < Formula
  include Language::Perl::Shebang

  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/M/MS/MSTROUT/SQL-Translator-1.61.tar.gz"
  sha256 "840e3c77cd48b47e1343c79ae8ef4fca46d036356d143d33528900740416dfe8"
  # license ["Artistic-1.0", "GPL-1.0"] - pending https://github.com/Homebrew/brew/pull/7953
  license "Artistic-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf06c23d417650d888cf49edd10ae3697e92cb7c0dc33ef07c530d33493155aa" => :catalina
    sha256 "d581943f0e91e5623b1ab053e212b6351513c81e04a77bc32b9626929f4e4667" => :mojave
    sha256 "185ef1f4c9feb68f4b8f65a9cda078cdc8a9600163ba67caf60f91d3dc62ce76" => :high_sierra
  end

  uses_from_macos "perl"

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.13.tar.gz"
    sha256 "45befdf0d95cbefe7c25a1daf293d85f780d6d2576146546e6828aad26e580f9"
  end

  resource "Package::Variant" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSTROUT/Package-Variant-1.003002.tar.gz"
    sha256 "b2ed849d2f4cdd66467512daa3f143266d6df810c5fae9175b252c57bc1536dc"
  end

  resource "strictures" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/strictures-2.000006.tar.gz"
    sha256 "09d57974a6d1b2380c802870fed471108f51170da81458e2751859f2714f8d57"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "--defaultdeps",
                                  "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    bin.find { |f| rewrite_shebang detected_perl_shebang, f }

    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    command = "#{bin}/sqlt -f MySQL -t PostgreSQL --no-comments -"
    sql_input = "create table sqlt ( id int AUTO_INCREMENT );"
    sql_output = <<~EOS
      CREATE TABLE "sqlt" (
        "id" serial
      );

    EOS
    assert_equal sql_output, pipe_output(command, sql_input)
  end
end

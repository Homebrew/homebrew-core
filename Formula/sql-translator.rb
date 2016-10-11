class SqlTranslator < Formula
  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/SQL-Translator-0.11021.tar.gz"
  sha256 "64cb38a9f78367bc115359a999003bbeb3c32cc75bba8306ec1a938fc441bfd1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9851c3298aaa5410dbd2458ee66ff0fe872be44eec0d433f3217e45fb5007ddc" => :sierra
    sha256 "63e86ac1d8db225650978de482e44049b8483dcfee0364fa7229d816def767ec" => :el_capitan
    sha256 "f80b97cd7f5bffe208f0402aa56b85ea141c4c310b59e4e37246472a277b136e" => :yosemite
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["PERL_MM_OPT"] = "INSTALL_BASE=#{libexec}"

    system "perl", "Makefile.PL", "--defaultdeps"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/sqlt*"]
    man1.install Dir["#{libexec}/man/man1/sqlt*.1"]
    bin.env_script_all_files libexec/"bin", :PERL5LIB => ENV["PERL5LIB"]
  end

  test do
    command = "#{bin}/sqlt -f MySQL -t PostgreSQL --no-comments -"
    sql_input = "create table sqlt ( id int AUTO_INCREMENT );"
    sql_output = <<-EOS.undent
      CREATE TABLE "sqlt" (
        "id" serial
      );

    EOS
    assert_equal sql_output, pipe_output(command, sql_input)
  end
end

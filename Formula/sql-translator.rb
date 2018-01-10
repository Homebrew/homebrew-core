class SqlTranslator < Formula
  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/SQL-Translator-0.11024.tar.gz"
  sha256 "5bde9d6f67850089ef35a9296d6f53e5ee8e991438366b71477f3f27c1581bb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e18c4a3f9b49dfb99675f12ce82a3762ea34970b741a9c1e3a70936234c0048e" => :high_sierra
    sha256 "ad3e150727e9163fc385a22ff049bac1ab013ec14fc2499be30c558daf5e2078" => :sierra
    sha256 "e90e93b46d07158b9221c55f3a95dc438a8adc0bf965492438a5dc6e66dad22d" => :el_capitan
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
    sql_output = <<~EOS
      CREATE TABLE "sqlt" (
        "id" serial
      );

    EOS
    assert_equal sql_output, pipe_output(command, sql_input)
  end
end

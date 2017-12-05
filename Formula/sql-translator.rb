class SqlTranslator < Formula
  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/SQL-Translator-0.11023.tar.gz"
  sha256 "5905a47b2861a11baa90b594f7d8f385a348e66c052cb935e3d78723c5a93b40"

  bottle do
    cellar :any_skip_relocation
    sha256 "f87e7806b60397f81c5809064461122212e0f315c537d56bf57c96f817ccbf15" => :high_sierra
    sha256 "818830904b111492162e3d4b15c6a60a8d8bc9a9ee36177d58a8a8a5cfc19852" => :sierra
    sha256 "da952c02e589eb260aa425983183edccd0d83b29a12d2e863e9f0cfee6f10dba" => :el_capitan
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

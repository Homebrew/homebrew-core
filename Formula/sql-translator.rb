class SqlTranslator < Formula
  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/SQL-Translator-0.11023.tar.gz"
  sha256 "5905a47b2861a11baa90b594f7d8f385a348e66c052cb935e3d78723c5a93b40"

  bottle do
    cellar :any_skip_relocation
    sha256 "df466a30cb68a8a08b1357006d7ebfda5c8916022dec5ea07e2bc460b19c7f45" => :high_sierra
    sha256 "985aed14180365adb98a1ac7f53886e734407d4bb13718913bb90f13e6118fa7" => :sierra
    sha256 "1303b6f25378895b08f1097e45771c0cab3b9d590f5089b7681d8c98572d228f" => :el_capitan
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

class SqlTranslator < Formula
  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/SQL-Translator-1.60.tar.gz"
  sha256 "6bb0cb32ca25da69df65e5de71f679f3ca90044064526fa336cabd342f220e87"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1c2de135fe29e2d9093ffd5e943f92e31f26ae02ac018dfd91378c868fca896" => :catalina
    sha256 "301a5bf24c4091a864526cc9a8db75aba078d09c076557653f488678272df469" => :mojave
    sha256 "e18c4a3f9b49dfb99675f12ce82a3762ea34970b741a9c1e3a70936234c0048e" => :high_sierra
    sha256 "ad3e150727e9163fc385a22ff049bac1ab013ec14fc2499be30c558daf5e2078" => :sierra
    sha256 "e90e93b46d07158b9221c55f3a95dc438a8adc0bf965492438a5dc6e66dad22d" => :el_capitan
  end

  uses_from_macos "perl"

  resource "Class::Method::Modifiers" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.13.tar.gz"
    sha256 "ab5807f71018a842de6b7a4826d6c1f24b8d5b09fcce5005a3309cf6ea40fd63"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.13.tar.gz"
    sha256 "45befdf0d95cbefe7c25a1daf293d85f780d6d2576146546e6828aad26e580f9"
  end

  resource "Import::Into" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Import-Into-1.002005.tar.gz"
    sha256 "bd9e77a3fb662b40b43b18d3280cd352edf9fad8d94283e518181cc1ce9f0567"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end

  resource "Moo" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.003006.tar.gz"
    sha256 "bcb2092ab18a45005b5e2e84465ebf3a4999d8e82a43a09f5a94d859ae7f2472"
  end

  resource "Package::Variant" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSTROUT/Package-Variant-1.003002.tar.gz"
    sha256 "b2ed849d2f4cdd66467512daa3f143266d6df810c5fae9175b252c57bc1536dc"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.001004.tar.gz"
    sha256 "92ba5712850a74102c93c942eb6e7f62f7a4f8f483734ed289d08b324c281687"
  end

  resource "strictures" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/strictures-2.000006.tar.gz"
    sha256 "09d57974a6d1b2380c802870fed471108f51170da81458e2751859f2714f8d57"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz"
    sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
    sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
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

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https://github.com/Homebrew/homebrew-core/issues/4936
    perl_files = Dir["#{bin}/sqlt*"]
    inreplace perl_files, "#!/usr/bin/env perl", "#!/usr/bin/perl"

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

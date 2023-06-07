require "language/perl"

class SqlTranslator < Formula
  include Language::Perl::Shebang

  desc "Manipulate structured data definitions (SQL and more)"
  homepage "https://github.com/dbsrgits/sql-translator/"
  url "https://cpan.metacpan.org/authors/id/I/IL/ILMARI/SQL-Translator-1.62.tar.gz"
  sha256 "0acd4ff9ac3a2f8d5d67199aac02cdc127e03888e479c51c7bbdc21b85c1ce24"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5b569d3339ab37e0c8e963f4c314f05cfa4a7607cabc0c3b8076171a1b98415"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b569d3339ab37e0c8e963f4c314f05cfa4a7607cabc0c3b8076171a1b98415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f655162409fb6814c1825c7ea6d6fc728fe48f92f2b8f0fd189e6e552112d97"
    sha256 cellar: :any_skip_relocation, ventura:        "37aa9abf5b79546cd961291b7ce884cbeb774b8c00f8830fba7837001e47111e"
    sha256 cellar: :any_skip_relocation, monterey:       "37aa9abf5b79546cd961291b7ce884cbeb774b8c00f8830fba7837001e47111e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f0b5a13935877fdf7e614525082c532ef76af02644dfda6acfdc427b6904668"
    sha256 cellar: :any_skip_relocation, catalina:       "e099ac2d4b73aca1beaa61f8a267c8334256c9ae5b0073f86a53a25e6f9ce9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f5316e2c4de49810fdeb2825f12739c2420438648fdb374715fdde3154b8df"
  end

  uses_from_macos "perl"

  on_linux do
    resource "Moo" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.003006.tar.gz"
      sha256 "bcb2092ab18a45005b5e2e84465ebf3a4999d8e82a43a09f5a94d859ae7f2472"
    end

    resource "Module::Runtime" do
      url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
      sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
    end

    resource "Sub::Quote" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006006.tar.gz"
      sha256 "6e4e2af42388fa6d2609e0e82417de7cc6be47223f576592c656c73c7524d89d"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.30.tar.gz"
      sha256 "da5bd0d5c903519bbf10bb9ba0cb7bcac0563882bcfe4503aee3fb143eddef6b"
    end

    resource "Import::Into" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Import-Into-1.002005.tar.gz"
      sha256 "bd9e77a3fb662b40b43b18d3280cd352edf9fad8d94283e518181cc1ce9f0567"
    end

    resource "Role::Tiny" do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.001004.tar.gz"
      sha256 "92ba5712850a74102c93c942eb6e7f62f7a4f8f483734ed289d08b324c281687"
    end

    resource "Class::Method::Modifiers" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.13.tar.gz"
      sha256 "ab5807f71018a842de6b7a4826d6c1f24b8d5b09fcce5005a3309cf6ea40fd63"
    end

    resource "DBI" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
      sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
    end

    resource "Carp::Clan" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Carp-Clan-6.08.tar.gz"
      sha256 "c75f92e34422cc5a65ab05d155842b701452434e9aefb649d6e2289c47ef6708"
    end

    resource "Parse::RecDescent" do
      url "https://cpan.metacpan.org/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz"
      sha256 "1943336a4cb54f1788a733f0827c0c55db4310d5eae15e542639c9dd85656e37"
    end
  end

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
    rewrite_shebang detected_perl_shebang, *bin.children

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

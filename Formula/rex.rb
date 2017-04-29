class Rex < Formula
  desc "Command-line tool which executes commands on remote servers."
  homepage "https://rexify.org"
  url "https://cpan.metacpan.org/authors/id/J/JF/JFRIED/Rex-1.5.0.tar.gz"
  sha256 "c042a0ed4920070d4508b6e7d2c36d28b3a5691938f2e0a0d7717977b44b82d0"

  depends_on :perl => "5.16"

  resource "Module::Build" do
    # AWS::Signature4 requires Module::Build v0.4205 and above, while standard
    # MacOS Perl installation has 0.4003
    url "http://search.cpan.org/CPAN/authors/id/L/LE/LEONT/Module-Build-0.4222.tar.gz"
    sha256 "e74b45d9a74736472b74830599cec0d1123f992760f9cd97104f94bee800b160"
  end

  resource "AWS::Signature4" do
    url "https://cpan.metacpan.org/authors/id/L/LD/LDS/AWS-Signature4-1.02.tar.gz"
    sha256 "20bbc16cb3454fe5e8cf34fe61f1a91fe26c3f17e449ff665fcbbb92ab443ebd"
  end

  resource "Clone" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.38.tar.gz"
    sha256 "9fb0534bb7ef6ca1f6cc1dc3f29750d6d424394d14c40efdc77832fad3cebde8"
  end

  resource "Date::Parse" do
    url "https://cpan.metacpan.org/authors/id/G/GB/GBARR/TimeDate-2.30.tar.gz"
    sha256 "75bd254871cb5853a6aa0403ac0be270cdd75c9d1b6639f18ecba63c15298e86"
  end

  resource "Devel::Caller" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Devel-Caller-2.06.tar.gz"
    sha256 "6a73ae6a292834255b90da9409205425305fcfe994b148dcb6d2d6ef628db7df"
  end

  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end

  resource "Exporter::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-0.042.tar.gz"
    sha256 "8f1622c5ebbfbcd519ead81df7917e48cb16cc527b1c46737b0459c3908a023f"
  end

  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/File-Listing-6.04.tar.gz"
    sha256 "1e0050fcd6789a2179ec0db282bf1e90fb92be35d1171588bd9c47d52d959cf5"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTML-Parser-3.72.tar.gz"
    sha256 "ec28c7e1d9e67c45eca197077f7cdc41ead1bb4c538c7f02a3296a4bb92f608b"
  end

  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end

  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Cookies-6.01.tar.gz"
    sha256 "f5d3ade383ce6389d80cb0d0356b643af80435bb036afd8edce335215ec5eb20"
  end

  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Daemon-6.01.tar.gz"
    sha256 "43fd867742701a3f9fcc7bd59838ab72c6490c0ebaf66901068ec6997514adc2"
  end

  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Date-6.02.tar.gz"
    sha256 "e8b9941da0f9f0c9c01068401a5e81341f0e3707d1c754f8e11f42a7e629e333"
  end

  resource "HTTP::Message" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/HTTP-Message-6.11.tar.gz"
    sha256 "e7b368077ae6a188d99920411d8f52a8e5acfb39574d4f5c24f46fd22533d81b"
  end

  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end

  resource "Hash::Merge" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/Hash-Merge-0.200.tar.gz"
    sha256 "47f9f03330b7595c94e73bdd17dc6682ba59d1cc89e63f4e319617f4bb122a64"
  end

  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.001.tar.gz"
    sha256 "ea78d2d743794adc028bc9589538eb867174b4e165d7d8b5f63486e6b828e7e0"
  end

  resource "IO::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
    sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
  end

  resource "Canary::Stability" do
    url "http://search.cpan.org/CPAN/authors/id/M/ML/MLEHMANN/Canary-Stability-2012.tar.gz"
    sha256 "fd240b111d834dbae9630c59b42fae2145ca35addc1965ea311edf0d07817107"
  end

  resource "JSON::XS" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/JSON-XS-3.02.tar.gz"
    sha256 "5f6a5944887d75f1d34440a2d9e69ef12e23f434af23acb143fb0241f40b02be"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.15.tar.gz"
    sha256 "6f349d45c21b1ec0501c4437dfcb70570940e6c3d5bff783bd91d4cddead8322"
  end

  resource "LWP::MediaTypes" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/LWP-MediaTypes-6.02.tar.gz"
    sha256 "18790b0cc5f0a51468495c3847b16738f785a2d460403595001e0b932e5db676"
  end

  resource "List::MoreUtils" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.416.tar.gz"
    sha256 "d2ce2f93a4fba8e20a602eba2405d08f5b28c23764a5273fb0abbc413f74c5a5"
  end

  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Net-HTTP-6.09.tar.gz"
    sha256 "52762b939d84806908ba544581c5708375f7938c3c0e496c128ca3fbc425e58d"
  end

  resource "Net::OpenSSH" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SALVA/Net-OpenSSH-0.74.tar.gz"
    sha256 "bd06e66cef82b5a07585deeddc91a093b32f4d080ae6b5e8033231030a1c27b6"
  end

  resource "PadWalker" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROBIN/PadWalker-2.2.tar.gz"
    sha256 "fc1df2084522e29e892da393f3719d2c1be0da022fdd89cff4b814167aecfea3"
  end

  resource "Sort::Naturally" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz"
    sha256 "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746"
  end

  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.37.tar.gz"
    sha256 "4a9383cf2e0e0194668fe2bd546e894ffad41d556b41d2f2f577c8db682db241"
  end

  resource "Text::Glob" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Text-Glob-0.10.tar.gz"
    sha256 "d0af0549a9dd1c70edcd3b1429ccc3702b79b873375b79cd2bdfe8870e337449"
  end

  resource "Types::Serialiser" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/Types-Serialiser-1.0.tar.gz"
    sha256 "7ad3347849d8a3da6470135018d6af5fd8e58b4057cd568c3813695f2a04730d"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.71.tar.gz"
    sha256 "9c8eca0d7f39e74bbc14706293e653b699238eeb1a7690cc9c136fb8c2644115"
  end

  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "XML::NamespaceSupport" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.11.tar.gz"
    sha256 "6d8151f0a3f102313d76b64bfd1c2d9ed46bfe63a16f038e7d860fda287b74ea"
  end

  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
    sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
  end

  resource "XML::Simple" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.22.tar.gz"
    sha256 "b9450ef22ea9644ae5d6ada086dc4300fa105be050a2030ebd4efd28c198eb49"
  end

  resource "XSLoader" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SAPER/XSLoader-0.24.tar.gz"
    sha256 "e819a35a6b8e55cb61b290159861f0dc00fe9d8c4f54578eb24f612d45c8d85f"
  end

  resource "YAML" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-1.18.tar.gz"
    sha256 "c8c4ebf538b5c9b4f53bf3c80a436229b2f28ecd4dbde54e22b470791d04fd39"
  end

  resource "common::sense" do
    url "https://cpan.metacpan.org/authors/id/M/ML/MLEHMANN/common-sense-3.74.tar.gz"
    sha256 "771f7d02abd1ded94d9e37d3f66e795c8d2026d04defbeb5b679ca058116bbf3"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |res|
      res.stage do
        perl_build
      end
    end

    perl_build
    (libexec/"lib").install "blib/lib/Rex", "blib/lib/Rex.pm"

    # Use system Perl
    inreplace("bin/rexify") { |s| s.gsub!(/^#!perl$/, "#!/usr/bin/env perl") }

    %w[rex rexify].each do |cmd|
      libexec.install "bin/#{cmd}"
      chmod 0755, libexec/cmd
      (bin/cmd).write_env_script(libexec/cmd, :PERL5LIB => ENV["PERL5LIB"])
      man1.install "blib/man1/#{cmd}.1"
    end
  end

  test do
    assert_match "\(R\)\?ex #{version}", shell_output("#{bin}/rex -v"), "rex -v is expected to print out Rex version"
    system bin/"rexify", "brewtest"
    assert (testpath/"brewtest/Rexfile").exist?, "rexify is expected to create a new Rex project and pre-populate its Rexfile"
  end

  private

  def perl_build
    if File.exist? "Makefile.PL"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "make", "install"
    elsif File.exist? "Build.PL"
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "./Build", "install"
    else
      raise "Unknown build system for #{res.name}"
    end
  end
end

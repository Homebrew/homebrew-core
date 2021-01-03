class Rex < Formula
  desc "Command-line tool which executes commands on remote servers"
  homepage "https://www.rexify.org"
  url "https://cpan.metacpan.org/authors/id/F/FE/FERKI/Rex-1.13.2.tar.gz"
  sha256 "0e994a13374295b9ac0803795b3c7296b73009f22e9210ce8c24716535b690bb"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0ca43e439023982668c5563f41340a82d3ae8c45159b457749c1ab0f15d3c5" => :catalina
    sha256 "24da3a602c3b434d0069244f546ed33f14e8bd3bbee1f7a99b91ca97a48b0c37" => :mojave
    sha256 "dc0b2bb90327f2fc716eb95655366fd7a3ac36d7880f25a69777c9976260d508" => :high_sierra
  end

  uses_from_macos "perl"

  on_macos do
    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.51.tar.gz"
      sha256 "6444154f5c2b410627de2e73cc70e48a181e857c8fb4ffce29e4bdef60b8f9a3"
    end
  end

  resource "Module::Build" do
    # AWS::Signature4 requires Module::Build v0.4205 and above, while standard
    # MacOS Perl installation has 0.4003
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
  end

  resource "AWS::Signature4" do
    url "https://cpan.metacpan.org/authors/id/L/LD/LDS/AWS-Signature4-1.02.tar.gz"
    sha256 "20bbc16cb3454fe5e8cf34fe61f1a91fe26c3f17e449ff665fcbbb92ab443ebd"
  end

  resource "Clone::Choose" do
    url "https://cpan.metacpan.org/authors/id/H/HE/HERMES/Clone-Choose-0.010.tar.gz"
    sha256 "5623481f58cee8edb96cd202aad0df5622d427e5f748b253851dfd62e5123632"
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
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.002002.tar.gz"
    sha256 "00f0b95716b18157132c6c118ded8ba31392563d19e490433e9a65382e707101"
  end

  resource "ExtUtils::MakeMaker" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.58.tar.gz"
    sha256 "aa73736cd926536c0f393f441d1b8742453573ad6efa2d855471e772f84c1eee"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.09.tar.gz"
    sha256 "903f017afaa5b78599cc90efc14ecccc8cc2ebfb636eb8c02f8f16ba861d1fe0"
  end

  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.12.tar.gz"
    sha256 "df47bed10c38670c780fd0116867d5fd4693604acde31ba63380dce04c4e1fa6"
  end

  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end

  resource "HTTP::Message" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.26.tar.gz"
    sha256 "6ce6c359de75c3bb86696a390189b485ec93e3ffc55326b6d044fa900f1725e1"
  end

  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end

  resource "Hash::Merge" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/Hash-Merge-0.300.tar.gz"
    sha256 "402fd52191d51415bb7163b7673fb4a108e3156493d7df931b8db4b2af757c40"
  end

  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end

  resource "IO::String" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
    sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
  end

  resource "JSON::MaybeXS" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/JSON-MaybeXS-1.004000.tar.gz"
    sha256 "59bda02e8f4474c73913723c608b539e2452e16c54ed7f0150c01aad06e0a126"
  end

  resource "LWP::MediaTypes" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end

  resource "List::MoreUtils" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz"
    sha256 "63b1f7842cd42d9b538d1e34e0330de5ff1559e4c2737342506418276f646527"
  end

  resource "List::MoreUtils::XS" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz"
    sha256 "e8ce46d57c179eecd8758293e9400ff300aaf20fefe0a9d15b9fe2302b9cb242"
  end

  resource "List::Util" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.55.tar.gz"
    sha256 "4d2bdc1c72a7bc4d69d6a5cc85bc7566497c3b183c6175b832784329d58feb4b"
  end

  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.19.tar.gz"
    sha256 "52b76ec13959522cae64d965f15da3d99dcb445eddd85d2ce4e4f4df385b2fc4"
  end

  resource "Net::OpenSSH" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SALVA/Net-OpenSSH-0.80.tar.gz"
    sha256 "fee093657df2b361472a2982859588a6e4bc5e1aee8118ece5eebfeafa8daeb3"
  end

  resource "PadWalker" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROBIN/PadWalker-2.5.tar.gz"
    sha256 "07b26abb841146af32072a8d68cb90176ffb176fd9268e6f2f7d106f817a0cd0"
  end

  resource "Sort::Naturally" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz"
    sha256 "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746"
  end

  resource "Term::ReadKey" do
    url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  resource "Text::Glob" do
    url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz"
    sha256 "069ccd49d3f0a2dedb115f4bdc9fbac07a83592840953d1fcdfc39eb9d305287"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-1.76.tar.gz"
    sha256 "b2c98e1d50d6f572483ee538a6f4ccc8d9185f91f0073fd8af7390898254413e"
  end

  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "XML::NamespaceSupport" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz"
    sha256 "47e995859f8dd0413aa3f22d350c4a62da652e854267aa0586ae544ae2bae5ef"
  end

  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
    sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
  end

  resource "XML::Simple" do
    url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz"
    sha256 "531fddaebea2416743eb5c4fdfab028f502123d9a220405a4100e68fc480dbf8"
  end

  resource "YAML" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-1.30.tar.gz"
    sha256 "5030a6d6cbffaf12583050bf552aa800d4646ca9678c187add649227f57479cd"
  end

  resource "inc::latest" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/inc-latest-0.500.tar.gz"
    sha256 "daa905f363c6a748deb7c408473870563fcac79b9e3e95b26e130a4a8dc3c611"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        # Work around restriction on 10.15+ where .bundle files cannot be loaded
        # from a relative path -- while in the middle of our build we need to
        # refer to them by their full path.  Workaround adapted from:
        #   https://github.com/fink/fink-distributions/issues/461#issuecomment-563331868
        inreplace "Makefile", "blib/", "$(shell pwd)/blib/" if r.name == "Term::ReadKey"
        system "make", "install"
      end
    end

    resources.each do |res|
      res.stage do
        perl_build
      end
    end

    perl_build
    (libexec/"lib").install "blib/lib/Rex", "blib/lib/Rex.pm"
    inreplace "bin/rex", "#!perl", "#!/usr/bin/env perl"
    inreplace "bin/rexify", "#!perl", "#!/usr/bin/env perl"

    %w[rex rexify].each do |cmd|
      libexec.install "bin/#{cmd}"
      chmod 0755, libexec/cmd
      (bin/cmd).write_env_script(libexec/cmd, PERL5LIB: ENV["PERL5LIB"])
      man1.install "blib/man1/#{cmd}.1"
    end
  end

  test do
    assert_match "\(R\)\?ex #{version}", shell_output("#{bin}/rex -v"), "rex -v is expected to print out Rex version"
    system bin/"rexify", "brewtest"
    assert_predicate testpath/"brewtest/Rexfile", :exist?,
                     "rexify is expected to create a new Rex project and pre-populate its Rexfile"
  end

  private

  def perl_build
    if File.exist? "Build.PL"
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "./Build", "install"
    elsif File.exist? "Makefile.PL"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "INC=-I#{MacOS.sdk_path}/System/Library/Perl/5.18/darwin-thread-multi-2level/CORE"
      system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "make", "install"
    else
      raise "Unknown build system for #{res.name}"
    end
  end
end

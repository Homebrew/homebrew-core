class Rex < Formula
  desc "Command-line tool which executes commands on remote servers"
  homepage "https://www.rexify.org"
  url "https://cpan.metacpan.org/authors/id/F/FE/FERKI/Rex-1.14.3.tar.gz"
  sha256 "027d3042ef940b67590e5989e96f22ae1e67ba744895c5dd3db569c05137025c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20f59893fa2dda833429d39b23d872855fe7a54c7bc3422dfdb7f04437bacd13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4ed59ecebc57d3c14c8c4556a1ffb351bd1471b4e02675f60b4fd97938da2c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cbae6519c968141a6c04d9ac0c139a81d3877b3b483be31094532d0290a61a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cbae6519c968141a6c04d9ac0c139a81d3877b3b483be31094532d0290a61a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "33c3755cd59ff9682953fcc3110d947dc02946f8695682350e9a866fe9d312ef"
    sha256 cellar: :any_skip_relocation, ventura:        "d431a10b19c69e47309f1576fd60087ebd3ebbf3a8c461c3d6f31262032e1200"
    sha256 cellar: :any_skip_relocation, monterey:       "d431a10b19c69e47309f1576fd60087ebd3ebbf3a8c461c3d6f31262032e1200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b00c01f568cace9db429eacff7c4fdbfe0e783cc0916de189701453fd32f3de"
  end

  uses_from_macos "perl", since: :big_sur

  on_system :linux, macos: :catalina_or_older do
    resource "Module::Build" do
      # AWS::Signature4 requires Module::Build v0.4205 and above, while standard
      # MacOS Perl installation has 0.4003
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4232.tar.gz"
      sha256 "67c82ee245d94ba06decfa25572ab75fdcd26a9009094289d8f45bc54041771b"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GARU/Clone-0.46.tar.gz"
      sha256 "aadeed5e4c8bd6bbdf68c0dd0066cb513e16ab9e5b4382dc4a0aafd55890697b"
    end

    resource "Clone::Choose" do
      url "https://cpan.metacpan.org/authors/id/H/HE/HERMES/Clone-Choose-0.010.tar.gz"
      sha256 "5623481f58cee8edb96cd202aad0df5622d427e5f748b253851dfd62e5123632"
    end

    resource "Exporter::Tiny" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006002.tar.gz"
      sha256 "6f295e2cbffb1dbc15bdb9dadc341671c1e0cd2bdf2d312b17526273c322638d"
    end

    resource "JSON::MaybeXS" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/JSON-MaybeXS-1.004005.tar.gz"
      sha256 "f5b6bc19f579e66b7299f8748b8ac3e171936dc4e7fcb72a8a257a9bd482a331"
    end

    resource "Scalar::Util" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.63.tar.gz"
      sha256 "cafbdf212f6827dc9a0dd3b57b6ee50e860586d7198228a33262d55c559eb2a9"
    end

    resource "YAML" do
      url "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-1.30.tar.gz"
      sha256 "5030a6d6cbffaf12583050bf552aa800d4646ca9678c187add649227f57479cd"
    end

    resource "File::ShareDir::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
      sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
    end

    resource "Devel::Caller" do
      url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Devel-Caller-2.07.tar.gz"
      sha256 "b679a2b18034b0b720de82c3708724c364b10a6ca164cbc67cdc3af283f3503f"
    end

    resource "Digest::HMAC" do
      url "https://cpan.metacpan.org/authors/id/A/AR/ARODLAND/Digest-HMAC-1.04.tar.gz"
      sha256 "d6bc8156aa275c44d794b7c18f44cdac4a58140245c959e6b19b2c3838b08ed4"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end

    resource "File::ShareDir" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.118.tar.gz"
      sha256 "3bb2a20ba35df958dc0a4f2306fc05d903d8b8c4de3c8beefce17739d281c958"
    end

    resource "HTML::Parser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.81.tar.gz"
      sha256 "c0910a5c8f92f8817edd06ccfd224ba1c2ebe8c10f551f032587a1fc83d62ff2"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
      sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
      sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
    end

    resource "ExtUtils::Config" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz"
      sha256 "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c"
    end

    resource "ExtUtils::Helpers" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz"
      sha256 "de901b6790a4557cf4ec908149e035783b125bf115eb9640feb1bc1c24c33416"
    end

    resource "ExtUtils::InstallPaths" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.012.tar.gz"
      sha256 "84735e3037bab1fdffa3c2508567ad412a785c91599db3c12593a50a1dd434ed"
    end

    resource "Module::Build::Tiny" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.046.tar.gz"
      sha256 "be193027e2debb4c9926434aaf1aa46c9fc7bf4db83dcc347eb6e359ee878289"
    end

    resource "HTTP::Daemon" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.16.tar.gz"
      sha256 "b38d092725e6fa4e0c4dc2a47e157070491bafa0dbe16c78a358e806aa7e173d"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "HTTP::Message" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.44.tar.gz"
      sha256 "398b647bf45aa972f432ec0111f6617742ba32fc773c6612d21f64ab4eacbca1"
    end

    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "IO::String" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz"
      sha256 "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
    end

    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.72.tar.gz"
      sha256 "e9b8354fd5e20be207afe23ddd584fcd59bf82998dc077decf684ba1dae5a05d"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.23.tar.gz"
      sha256 "0d65c09dd6c8589b2ae1118174d3c1a61703b6ecfc14a3442a8c74af65e0c94e"
    end

    resource "NetAddr::IP" do
      url "https://cpan.metacpan.org/authors/id/M/MI/MIKER/NetAddr-IP-4.079.tar.gz"
      sha256 "ec5a82dfb7028bcd28bb3d569f95d87dd4166cc19867f2184ed3a59f6d6ca0e7"
    end

    resource "PadWalker" do
      url "https://cpan.metacpan.org/authors/id/R/RO/ROBIN/PadWalker-2.5.tar.gz"
      sha256 "07b26abb841146af32072a8d68cb90176ffb176fd9268e6f2f7d106f817a0cd0"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end

    resource "Text::Glob" do
      url "https://cpan.metacpan.org/authors/id/R/RC/RCLAMP/Text-Glob-0.11.tar.gz"
      sha256 "069ccd49d3f0a2dedb115f4bdc9fbac07a83592840953d1fcdfc39eb9d305287"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/S/SI/SIMBABQUE/URI-5.19.tar.gz"
      sha256 "8fed5f819905c8a8e18f4447034322d042c3536b43c13ac1f09ba92e1a50a394"
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
  end

  resource "AWS::Signature4" do
    url "https://cpan.metacpan.org/authors/id/L/LD/LDS/AWS-Signature4-1.02.tar.gz"
    sha256 "20bbc16cb3454fe5e8cf34fe61f1a91fe26c3f17e449ff665fcbbb92ab443ebd"
  end

  resource "Data::Validate::IP" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Data-Validate-IP-0.31.tar.gz"
    sha256 "734aff86b6f9cad40e1c4da81f28faf18e0802c76a566d95e5613d4318182fc1"
  end

  resource "Hash::Merge" do
    url "https://cpan.metacpan.org/authors/id/H/HE/HERMES/Hash-Merge-0.302.tar.gz"
    sha256 "ae0522f76539608b61dde14670e79677e0f391036832f70a21f31adde2538644"
  end

  resource "Net::OpenSSH" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SALVA/Net-OpenSSH-0.84.tar.gz"
    sha256 "8780e62f01b1cf0db43c9cb705c94ff4949b032233be4be91fc91abc791539f8"
  end

  resource "Sort::Naturally" do
    url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/Sort-Naturally-1.03.tar.gz"
    sha256 "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV["PERL_MM_USE_DEFAULT"] = "1"

    resources.each do |res|
      res.stage do
        perl_build
      end
    end

    perl_build
    (libexec/"lib").install "blib/lib/Rex", "blib/lib/Rex.pm"

    %w[rex rexify].each do |cmd|
      libexec.install "bin/#{cmd}"
      chmod 0755, libexec/cmd
      (bin/cmd).write_env_script(libexec/cmd, PERL5LIB: ENV["PERL5LIB"])
      man1.install "blib/man1/#{cmd}.1"
    end
  end

  test do
    assert_match "(R)?ex #{version}", shell_output("#{bin}/rex -v"), "rex -v is expected to print out Rex version"
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
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
      system "make", "install"
    else
      raise "Unknown build system for #{res.name}"
    end
  end
end

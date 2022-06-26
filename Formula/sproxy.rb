class Sproxy < Formula
  desc "HTTP proxy server collecting URLs in a 'siege-friendly' manner"
  homepage "https://www.joedog.org/sproxy-home/"
  url "http://download.joedog.org/sproxy/sproxy-1.02.tar.gz"
  sha256 "29b84ba66112382c948dc8c498a441e5e6d07d2cd5ed3077e388da3525526b72"

  livecheck do
    url "http://download.joedog.org/sproxy/"
    regex(/href=.*?sproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f13338cbd96aee85706f30ab752d6c7ea338b9876eb43444fbaf2c8523a09e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2558b7f1308c8bc08667c8e51d40b1c8df05280fa8c5f003f6dec07561089c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "f810e4c841a81313b77f81dec82b1cdd1b4952d6625d8590aadb581e388edafb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0feb23f8381e7e40ce846974be822ba97d42658a721582320468355193dc4851"
    sha256 cellar: :any_skip_relocation, catalina:       "ee0bff8062b0d007a9b762d35af1879e8abcf7203dae265d1a70ade53047af90"
    sha256 cellar: :any_skip_relocation, mojave:         "2d689087925622e4f7e2c2572c2339c62a6c2b891bce7093bcd664f1a15c28d9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "326b01fa9a1370c54929ae4c11d1b67b2238875eca8188365486b9c2a374264f"
    sha256 cellar: :any_skip_relocation, sierra:         "8d57317644b76b465adc5caf984f1e3cf57f9486f642705eee66128adbcf3589"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4ed786b0b05ca3c88d5904e3119d84725a9f9bedf5d952c055f22a81661a825c"
    sha256 cellar: :any_skip_relocation, yosemite:       "19da9a5b680a860e721ec60763dd48e9a5213505ee643703abcdc66707e8ce51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713ebc755ddb821e5e0bd17a13dc0a274645c7478f5682cd9407ddadb3e93c31"
  end

  # Only needed due to the change to "Makefile.am"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "perl"

  on_linux do
    depends_on "openssl@1.1"

    resource "File::Remove" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.60.tar.gz"
      sha256 "e86e2a40ffedc6d5697d071503fd6ba14a5f9b8220af3af022110d8e724f8ca6"
    end

    resource "YAML::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/YAML-Tiny-1.73.tar.gz"
      sha256 "bc315fa12e8f1e3ee5e2f430d90b708a5dc7e47c867dba8dce3a6b8fbe257744"
    end

    resource "Module::Install" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Module-Install-1.19.tar.gz"
      sha256 "1a53a78ddf3ab9e3c03fc5e354b436319a944cba4281baf0b904fa932a13011b"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz"
      sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
    end

    resource "HTML::Parser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.76.tar.gz"
      sha256 "64d9e2eb2b420f1492da01ec0e6976363245b4be9290f03f10b7d2cb63fa2f61"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.09.tar.gz"
      sha256 "03e63ada499d2645c435a57551f041f3943970492baa3b3338246dab6f1fae0a"
    end

    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.64.tar.gz"
      sha256 "48335e0992b4875bd73c6661439f3506c2c6d92b5dd601582b8dc22e767d3dae"
    end

    resource "HTTP::Request" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.36.tar.gz"
      sha256 "576a53b486af87db56261a36099776370c06f0087d179fc8c7bb803b48cddd76"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
      sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
      sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
    end

    resource "HTTP::Daemon" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.14.tar.gz"
      sha256 "f0767e7f3cbb80b21313c761f07ad8ed253bce9fa2d0ba806b3fb72d309b2e1d"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end
  end

  def install
    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_create_path "PERL5LIB", lib/"sproxy"
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        end
      end
    end

    # Prevents "ERROR: Can't create '/usr/local/share/man/man3'"; also fixes an
    # audit violation triggered if the man page is installed in #{prefix}/man.
    # After making the change below and running autoreconf, the default ends up
    # being the same as #{man}, so there's no need for us to pass --mandir to
    # configure, though, as a result of this change, that flag would be honored.
    # Reported 10th May 2016 to https://www.joedog.org/support/
    inreplace "doc/Makefile.am", "$(prefix)/man", "$(mandir)"
    inreplace "lib/Makefile.am", "Makefile.PL", "Makefile.PL PREFIX=$(prefix)"

    # Only needed due to the change to "Makefile.am"
    system "autoreconf", "-fiv"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # sproxy must be wrapped in an ENV script on Linux so it can find
    # the additional Perl dependencies
    unless OS.mac?
      bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
      chmod 0755, libexec/"bin/sproxy"
    end
  end

  test do
    assert_match "SPROXY v#{version}-", shell_output("#{bin}/sproxy -V")
  end
end

class Sproxy < Formula
  desc "HTTP proxy server collecting URLs in a 'siege-friendly' manner"
  homepage "https://www.joedog.org/sproxy-home/"
  url "https://download.joedog.org/sproxy/sproxy-1.02.tar.gz"
  sha256 "29b84ba66112382c948dc8c498a441e5e6d07d2cd5ed3077e388da3525526b72"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://download.joedog.org/sproxy/"
    regex(/href=.*?sproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2e720f9fc39225fa4b382c6a54d510035893fe1cf0dcb44f28a73bb2f8237c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ae603617df32ac15e8cf5548ff5f230fcc33e0abc52af64a31bb00810f0aedd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd501fbd874421fd288cc4af5c4589f9eb842027c5938d84c598d0bec8a6c1f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf109934bc851cb45e6d6a9c24caff018e3ad0d1ebf45fa45d3c27291f7bcddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf109934bc851cb45e6d6a9c24caff018e3ad0d1ebf45fa45d3c27291f7bcddd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8c092d79cd0096d0d626cb9df9712e213e6fb6a814969c408feb2714e04917a"
    sha256 cellar: :any_skip_relocation, sonoma:         "19d8287f1648316caee4f7888c57fa805c4c790c477557a11622f22aedb91905"
    sha256 cellar: :any_skip_relocation, ventura:        "ba5b54502dcbb781c47640129208bfbd794770262afbcc2909773f01f2938687"
    sha256 cellar: :any_skip_relocation, monterey:       "ba5b54502dcbb781c47640129208bfbd794770262afbcc2909773f01f2938687"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0bbfcf15c625d3fc022b0d1960f05a05bbd2e0a7f21458f92dbd537cd0a614a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8924c72b741d24b2ea9f0c59ce12725ef3ca551fd526ab48c77051c943afddce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eefc2816eb2f502c05a7713f2d34efc56f81016e9fdef5c86299c04f69bd734"
  end

  # Only needed due to the change to "Makefile.am"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"

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
      ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

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
    inreplace "lib/Makefile.am",
              "Makefile.PL",
              "Makefile.PL PREFIX=$(prefix) INSTALLSITEMAN3DIR=$(mandir)/man3"

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

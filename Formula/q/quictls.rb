class Quictls < Formula
  desc "TLS/SSL and crypto library with QUIC APIs"
  homepage "https://github.com/quictls/openssl"
  url "https://github.com/quictls/openssl/archive/refs/tags/openssl-3.1.5-quic1.tar.gz"
  version "3.1.5-quic1"
  sha256 "928a0c484fca5a5b9ae484e7b14e6691e946220d77d86ac4031cbb408655b644"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^openssl[._-]v?(\d(?:\.\d)+[+._-]quic\d*)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "08beb28e31675db80511b2b696cf68449b213ac987563ee3375ab1aad920e48d"
    sha256 arm64_ventura:  "b33b84c2685bcffc0e842ee5c759d7d0bbde83609d8f85ea3f7c96d2ef39c66a"
    sha256 arm64_monterey: "15fef5e6c9c440c9d247845902723cce3ab285bf977441e2762b4f972611f66f"
    sha256 sonoma:         "37515eb8535ec78718c285f85b4e00d48200169e06a47989510d2ca4d4a2f3b2"
    sha256 ventura:        "c44036f24d7f2b57f823b484b0c31d7686f9f213b3acab040b231097f72bb8ef"
    sha256 monterey:       "22ae5e6a9455b9a4ec03566f8bcf74d8b62f35d87ca00a94b5696defb902056a"
    sha256 x86_64_linux:   "163a9a537be0d3df35db03097596b0761184852ed0b3cd1f2810d1edaf1746e2"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.48.tar.gz"
      sha256 "e73ff89c81c1a53f6baeef6816841b89d3384403ad97422a7da9d1eeb20ef9c5"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302198.tar.gz"
      sha256 "1dc07bcffd23e49983433c948de3e3f377e6e849ad7fe3432c717fa782024faa"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
          system "make", "install"
        end
      end
    end

    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = Formula["perl"].opt_bin/"perl" if which("perl") == Formula["perl"].opt_bin/"perl"

    # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
    # SSLv3 & zlib are off by default with 1.1.0 but this may not
    # be obvious to everyone, so explicitly state it for now to
    # help debug inevitable breakage.
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{quictlsdir}
      --libdir=#{lib}
      no-ssl3
      no-ssl3-method
      no-zlib
    ]

    if OS.linux?
      args += (ENV.cflags || "").split
      args += (ENV.cppflags || "").split
      args += (ENV.ldflags || "").split
    end

    if OS.mac?
      args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    quictlsdir.mkpath
    system "perl", "./Configure", *args
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def quictlsdir
    etc/"quictls"
  end

  def post_install
    rm(quictlsdir/"cert.pem") if (quictlsdir/"cert.pem").exist?
    quictlsdir.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{quictlsdir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate pkgetc/"openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end

class Quictls < Formula
  desc "TLS/SSL and crypto library with QUIC APIs"
  homepage "https://github.com/quictls/openssl"
  url "https://github.com/quictls/openssl/archive/refs/tags/openssl-3.3.0-quic1.tar.gz"
  version "3.3.0-quic1"
  sha256 "78d675d94c0ac3a8b44073f0c2b373d948c5afd12b25c9e245262f563307a566"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^openssl[._-]v?(\d(?:\.\d)+[+._-]quic\d*)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7d899abd908cd31282776b93be0a4b8d573d906669496b6b5a2fc7eb73059ae2"
    sha256 arm64_sequoia: "d23ad26d2efb1dc8f1a9030696fe96ed1f39df568093ef64fa9c264c28da574a"
    sha256 arm64_sonoma:  "a2b2a74d18ef19a9753296517bd60b9e26c4139238f76f4f252dd8ee4656beca"
    sha256 arm64_ventura: "b4a00903b3a19f1f486eb724cd41ef1dbc332cbef1961dadf8f08d23007e2b4d"
    sha256 sonoma:        "d62a944f9b45478aff3b5b1bd14ad7913ac48d23b7a9d037568d04ba539f2449"
    sha256 ventura:       "0d4335f3009b02faff17bc049ed596dfae00c82455a664dc43b230398bf3574e"
    sha256 arm64_linux:   "badde66c7078fe9f19a77c7ef6c75f2f3503b502bc6c1b268d962b94cd904773"
    sha256 x86_64_linux:  "3e1326258525b2d2ea8fb9bf9f84625790136617ca3abf2a2ee8b5912180aaab"
  end

  keg_only "it conflicts with OpenSSL"

  deprecate! date: "2025-10-02", because: :repo_archived

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.50.tar.gz"
      sha256 "79b6acdc444f1924cd4c2e9ed868bdc6e09580021aca8ff078ede2ffef8a6f54"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302204.tar.gz"
      sha256 "03749d1027a7817ca7f11e420ef72951f20a849ea65af2eb595f34df47d1226e"
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
    assert_path_exists pkgetc/"openssl.cnf", "OpenSSL requires the .cnf file for some functionality"

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

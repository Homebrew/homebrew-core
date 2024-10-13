class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.73.tar.gz"
  sha256 "bc917c3bcd943a4d632360c067977a31e85e385f5f4845f69749bce88183cb38"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9ebe0bff4ff989f7c813acfc0f3babc0da844d32fc8573f312071de235173258"
    sha256 cellar: :any,                 arm64_sonoma:   "e906bc39b199cd1a85e6504a76836dafa2ee85512412b6d75a12166c59d39d75"
    sha256 cellar: :any,                 arm64_ventura:  "31c84b034d02b835932c600829d9b2eaac27c503cd01ccb7237c05fe7922bd29"
    sha256 cellar: :any,                 arm64_monterey: "91f4e0489c4e7c2186bdeea494fc4190359bc3f1390ee8050997a8beaddaf517"
    sha256 cellar: :any,                 sonoma:         "af36b6ee1b582ccc58fc5fb2e47aefbe6d33751de4a0608f6eb5dc26463b16c1"
    sha256 cellar: :any,                 ventura:        "48d97fc738dd0b067cbaaff849b903c8b1cf3f96eca9db64420039c4ae038336"
    sha256 cellar: :any,                 monterey:       "dcceef2f331ca52a7bb7d59eeeeefe4f406f72bc10f6e431dc0b2c23bd9d2d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9ad0c808b6d741f750e916b5dd5a3ac510b48b12429a99cb0e6c919774e3b6"
  end

  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--disable-systemd",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"

    # This programmatically recreates pem creation used in the tools Makefile
    # which would usually require interactivity to resolve.
    cd "tools" do
      system "dd", "if=/dev/urandom", "of=stunnel.rnd", "bs=256", "count=1"
      system "#{Formula["openssl@3"].opt_bin}/openssl", "req",
        "-new", "-x509",
        "-days", "365",
        "-rand", "stunnel.rnd",
        "-config", "openssl.cnf",
        "-out", "stunnel.pem",
        "-keyout", "stunnel.pem",
        "-sha256",
        "-subj", "/C=PL/ST=Mazovia Province/L=Warsaw/O=Stunnel Developers/OU=Provisional CA/CN=localhost/"
      chmod 0600, "stunnel.pem"
      (etc/"stunnel").install "stunnel.pem"
    end
  end

  def caveats
    <<~EOS
      A bogus SSL server certificate has been installed to:
        #{etc}/stunnel/stunnel.pem

      This certificate will be used by default unless a config file says otherwise!
      Stunnel will refuse to load the sample configuration file if left unedited.

      In your stunnel configuration, specify a SSL certificate with
      the "cert =" option for each service.

      To use Stunnel with Homebrew services, make sure to set "foreground = yes" in
      your Stunnel configuration.
    EOS
  end

  service do
    run [opt_bin/"stunnel"]
  end

  test do
    user = if OS.mac?
      "nobody"
    else
      ENV["USER"]
    end
    (testpath/"tstunnel.conf").write <<~EOS
      cert = #{etc}/stunnel/stunnel.pem

      setuid = #{user}
      setgid = #{user}

      [pop3s]
      accept  = 995
      connect = 110

      [imaps]
      accept  = 993
      connect = 143
    EOS

    assert_match "successful", pipe_output("#{bin}/stunnel #{testpath}/tstunnel.conf 2>&1")
  end
end

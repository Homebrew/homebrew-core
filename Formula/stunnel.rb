class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.50.tar.gz"
  mirror "https://www.usenix.org.uk/mirrors/stunnel/stunnel-5.50.tar.gz"
  sha256 "951d92502908b852a297bd9308568f7c36598670b84286d3e05d4a3a550c0149"

  bottle do
    cellar :any
    sha256 "e0fb492f1f33313f9b826df1c215b3e9249838ca6b86fc0f16ad82a06aa360ff" => :mojave
    sha256 "992e36736d37859b9554a2c31ad76ed48d2ab112f1d93c440f1302cf6ce560fe" => :high_sierra
    sha256 "ce75cbd34d1aa2d22faadbc78666e8663c6b5a629ccd76f1e7a343486aea95d8" => :sierra
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--disable-systemd",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"

    # This programmatically recreates pem creation used in the tools Makefile
    # which would usually require interactivity to resolve.
    cd "tools" do
      args = %w[req -new -x509 -days 365 -rand stunnel.rnd -config
                openssl.cnf -out stunnel.pem -keyout stunnel.pem -sha256 -subj
                /C=PL/ST=Mazovia\ Province/L=Warsaw/O=Stunnel\ Developers/OU=Provisional\ CA/CN=localhost/]
      system "dd", "if=/dev/urandom", "of=stunnel.rnd", "bs=256", "count=1"
      system "#{Formula["openssl"].opt_bin}/openssl", *args
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
    EOS
  end

  test do
    (testpath/"tstunnel.conf").write <<~EOS
      cert = #{etc}/stunnel/stunnel.pem

      setuid = nobody
      setgid = nobody

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

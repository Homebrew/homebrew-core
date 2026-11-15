class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.82.tar.gz"
  sha256 "8e7438ccd6b3a2ab05182d0846e112a56a7f557ecdee40de07bf67820008bef7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4044153e9399a0fb0b9cef7909bbd2af734d8544b7ad9f97df792cb33673ae11"
    sha256 cellar: :any, arm64_tahoe:       "03ff961d9d1484ef6c5ec0102d2d8ce0ea63c9e79289a04d131507aa94dd1bf3"
    sha256 cellar: :any, arm64_sequoia:     "2ca637904a66de67e377c34661fd60702398032ff1a71805e021e755bc1a9066"
    sha256 cellar: :any, arm64_linux:       "70353f0367b261072717e6a4b7e8fd1269682f5d488503733055fd27ff89ee1b"
    sha256 cellar: :any, x86_64_linux:      "3d092ce85bba5c37aae0be718e3f4dfe10530468281f6deadafcf0375b89f17d"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    openssl = "openssl@4"
    system "./configure", "--disable-libwrap",
                          "--disable-silent-rules",
                          "--disable-systemd",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--mandir=#{man}",
                          "--with-ssl=#{formula_opt_prefix(openssl)}",
                          *std_configure_args
    system "make", "install"

    # This programmatically recreates pem creation used in the tools Makefile
    # which would usually require interactivity to resolve.
    cd "tools" do
      system "dd", "if=/dev/urandom", "of=stunnel.rnd", "bs=256", "count=1"
      system "#{formula_opt_bin(openssl)}/openssl", "req",
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
    (testpath/"tstunnel.conf").write <<~CONF
      cert = #{etc}/stunnel/stunnel.pem

      setuid = #{user}
      setgid = #{user}

      [pop3s]
      accept  = 995
      connect = 110

      [imaps]
      accept  = 993
      connect = 143
    CONF

    assert_match "successful", pipe_output("#{bin}/stunnel #{testpath}/tstunnel.conf 2>&1")
  end
end

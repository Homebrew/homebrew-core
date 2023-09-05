class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.70.tar.gz"
  sha256 "7bbc7b9e9a988d76301325db4c110ec360a98ffb8a221c7accbff9c0a8bae2f3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3e7fd50914a2755852f86b378cd6c3b37f3fa2b89ca5ce811f35bd5879747ee"
    sha256 cellar: :any,                 arm64_monterey: "e0e4e78fd7b823a8dd5c970d1f5cf54820119ef7125b43b24dcf80e0a0387029"
    sha256 cellar: :any,                 arm64_big_sur:  "7c60137bcf285268bff1eb6fffc380ec4d534d98b54e553cc3f6b5d4fb0c5bc3"
    sha256 cellar: :any,                 ventura:        "64b37b9eb2b294bdb7f478675536dfc7032a26c4072801640fa6dd9c6e817fc5"
    sha256 cellar: :any,                 monterey:       "9f70e64c9ceba451d790ebcd34b6e480d10697d511dce82afee839d4bfb4221b"
    sha256 cellar: :any,                 big_sur:        "10c2fd4bb8986a45d3c114ef5e03ded4b16ebf8afb2828ed847f9839647d3cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85856c87cb80d5b7a5159ec26ad9ee792cba186824b19a710a57754cc2555f3"
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

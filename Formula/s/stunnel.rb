class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.76.tar.gz"
  sha256 "cda37eb4d0fb1e129718ed27ad77b5735e899394ce040bb2be28bbb937fd79e1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3059de4bf0d55781349a2070dfa8126738f2e6eac883abe43c73f27528bf2967"
    sha256 cellar: :any,                 arm64_sequoia: "69163d8ae9a729ae91bd2cd702d080dbfd96c2a36793c01aa54afb705e9ec322"
    sha256 cellar: :any,                 arm64_sonoma:  "878d22476a78641ad84e4097885227efc548a2e961b0dc4881532bd52e2be353"
    sha256 cellar: :any,                 sonoma:        "7cfdd73bd9c66c5b79fff4273f980e7e1f7b0dd5d2830c74c392295fc7705e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "474a76737abb1ebd7b28376b82d400216ee1bc96df67e9f308dd27aea1fc3e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d119212f3a46c3069428dd7b166a51ed3221ecc12a09282e7031047927e1f9f"
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

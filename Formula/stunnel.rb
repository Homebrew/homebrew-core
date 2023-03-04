class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.69.tar.gz"
  sha256 "1ff7d9f30884c75b98c8a0a4e1534fa79adcada2322635e6787337b4e38fdb81"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0d1539f2071a9e7a752036d8ca6679e48ed77a40b4fb8408e6a68650d1a38a1"
    sha256 cellar: :any,                 arm64_monterey: "892c1dee62844c4a5d00540893859c131e58eac02370d7741bf324bff85d72b9"
    sha256 cellar: :any,                 arm64_big_sur:  "8389dd4328cbca713a88d3e2d42cf3ccb7ec9b0a8d06547aa1e108ed77696dae"
    sha256 cellar: :any,                 ventura:        "d76c2c4265d508ff37e904fb8f69d27512e6f93b5d6c6926cc52f3d3d10dfbe6"
    sha256 cellar: :any,                 monterey:       "9820ce3a8931277567507ce386ff1a6553016d9ac2488db01052e1c9224049a0"
    sha256 cellar: :any,                 big_sur:        "ca3e0fc1b83a4e8786232af55a6b76e896f623546048448c4120a7917f083954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b6e6fa56d48b798420d5d1681b7470f79f49cdecacba2d7ae8e8e06d1af404"
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

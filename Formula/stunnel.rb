class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.67.tar.gz"
  sha256 "3086939ee6407516c59b0ba3fbf555338f9d52f459bcab6337c0f00e91ea8456"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b2e1a1f0cd77b6ba502eda29afd41ed4206923d98d9e49a9e12ff3dade2be61"
    sha256 cellar: :any,                 arm64_monterey: "b6f21a7a7aae8934324cf27798f14dbe6e6d12fc33355dcc787bee438c67734e"
    sha256 cellar: :any,                 arm64_big_sur:  "bd42513cfb34768bede1f403a525264792e9a0154371444bff812fe1240fad42"
    sha256 cellar: :any,                 ventura:        "cca3b8088572dfdd24f3c2e9b28f3c87bc2e2485ee219d04520f743c6bba1fd8"
    sha256 cellar: :any,                 monterey:       "ec23a90b002b6581abc3392fc1831ea1caaca2babaf325372dbb7a0f36a9cf6e"
    sha256 cellar: :any,                 big_sur:        "17c6e31bdb6f96cf33b232654f401b60bf03eac5a2bf1b3874b36fa700bd961b"
    sha256 cellar: :any,                 catalina:       "c568c4232dbbf3af31f3d93c15b9f8a4f8a1ff7df938b67f51809cde275689e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f443ea4d37bfee124aac63d4160632b313c56e322751dc2156545cf2354fb1f7"
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

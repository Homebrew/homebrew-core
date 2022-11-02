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
    sha256 cellar: :any,                 arm64_ventura:  "0925cc60df1d10978f09c8e06670575800b7aeae46ad7190a0c6fbdca156c52b"
    sha256 cellar: :any,                 arm64_monterey: "468aa86e69cb4a710a21634dfbd56ef5e82ce0bc0b03689217919c3a1b721fa1"
    sha256 cellar: :any,                 arm64_big_sur:  "55e7e532bfa181a33ad8b0cd299492a5aacd71e7ffb3e4574028fd8fd06cf503"
    sha256 cellar: :any,                 monterey:       "6632bf1c83320716620e6ff98859e8a9c74e531000504490a56b500a88f900c8"
    sha256 cellar: :any,                 big_sur:        "38042e481912e9e7a5a00d29277c3ffecb6a2aa6c143e188337b65b0d3e73cfa"
    sha256 cellar: :any,                 catalina:       "1b5725913ff7d90afbb3cbb088989a9664b908734174a3933905a65d70d3a4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac8acc1b13e79b8067cb9267ab3c21630392fef798610186599dc526655da0e"
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

class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.71.tar.gz"
  sha256 "f023aae837c2d32deb920831a5ee1081e11c78a5d57340f8e6f0829f031017f5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5e2aa362868c487ba5669305dc7b0f4ef4ddcc093cde5f4274862ba85f790d9"
    sha256 cellar: :any,                 arm64_ventura:  "0881a96a5678a80467c2b6b298cd350c7928cb0d20727f4690546c79503d6907"
    sha256 cellar: :any,                 arm64_monterey: "4043ea42a70b6498bd5ff8a90dbb695f1e244c760d29a724318ce32adce12414"
    sha256 cellar: :any,                 arm64_big_sur:  "b50815761e7c64635fd2c97a4aa13a467bec622ff47916fa5df2e85b69df8ad9"
    sha256 cellar: :any,                 sonoma:         "55709104b448aa0ddb5a3915dd1de58b430f4e4204aaf3773a0721c29cddc75d"
    sha256 cellar: :any,                 ventura:        "c928f970421ab4bfcc7272fb77adb13dc903e6292d4708bef20fe8854c8d3b31"
    sha256 cellar: :any,                 monterey:       "b3b390f32bd0c433d23eb4597a46435549ecd0afd62299e6006a91de20bf98db"
    sha256 cellar: :any,                 big_sur:        "bb589c337cae66dd6096fb6fa094ef8b17fbb31482ead130b1b341daf1ea044f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9d632f01a97ce53042d0bfbf3407d880b629069080a7d7d59cd6ed99d11a20"
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

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
    sha256 cellar: :any,                 arm64_ventura:  "4d3d865982840b1662a3058e106fbce761241a8ec4aa8998d71c8e007653028a"
    sha256 cellar: :any,                 arm64_monterey: "2d4b8d9eaae526b0386afd3b6679d02eb2b23579c78b84dd9055a826cd9d77b8"
    sha256 cellar: :any,                 arm64_big_sur:  "ff2b75c783a359a8a12347de55979f45e650c1cb0b58267c39b22bcffbf2d6d3"
    sha256 cellar: :any,                 ventura:        "ad0e4c4b1cccfb33b03d704f4a71e8b0d61c09f89fccffd6b8421fca341ceb6a"
    sha256 cellar: :any,                 monterey:       "9e3cfb283e6a94b9a935f8cdf2e4408a6c04ed945d0c3d48fea01dc6d0654dc3"
    sha256 cellar: :any,                 big_sur:        "cd7b4eb6c115a163ef8df9f93bde1ea800c2488a1c9c29a6da73df30fd5af3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea23482d88b174665da5b10b7b470a20a6b39163c6a1eb7414ed08645c4ba2c1"
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

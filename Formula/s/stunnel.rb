class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.75.tar.gz"
  sha256 "0c1ef0ed85240974dccb94fe74fb92d6383474c7c0d10e8796d1f781a3ba5683"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a17023a0390c52c62815c836798580f22c21165dedad0399f1523a03fd4f211"
    sha256 cellar: :any,                 arm64_sonoma:  "b52fe8808e516c6bc8fd521949770a79f98fea641d378384ca4658c35a0c3ff6"
    sha256 cellar: :any,                 arm64_ventura: "9d56d29e77ff1815a00aeed94563c0ad74083444bfc12509a7e1bb577e54c011"
    sha256 cellar: :any,                 sonoma:        "e5be8df8fbacccc56d65dd5b7fe6737208f80403f5fe497672393097e369e7b8"
    sha256 cellar: :any,                 ventura:       "5d1c9cceac9515413bbfb32ce8e99b7375915c17af020f850969be0c9cf2f0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af223c620740de6c81733ce26bcb3d025b58a23a3b52b0d19cc1c810e1cf7700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66a3d40d99cf4bc99eb9c070446687da88f41fb2f8569212a180030ab58c47e"
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

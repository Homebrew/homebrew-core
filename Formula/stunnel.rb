class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.60.tar.gz"
  sha256 "c45d765b1521861fea9b03b425b9dd7d48b3055128c0aec673bba5ef9b8f787d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "8f1162bf25fb40556bffe872eec87dbfa71b9fde8ae88f0424c79991dbac42ba"
    sha256 cellar: :any,                 arm64_big_sur:  "bfd5b6175001e46acdb8751e59d5de7a13a1222fc09309e85a67f70aa35893db"
    sha256 cellar: :any,                 monterey:       "d52bb3778c311966be44035870dd2179b566df6e979b00a4c607a1515421314d"
    sha256 cellar: :any,                 big_sur:        "db1410a067d25b6286f78d2e8f78f49440afeeee469e0640014e487a1516cd5a"
    sha256 cellar: :any,                 catalina:       "b05b0d7872c0ee97edf42d1e9acfe7cc52bc8f2ba3daa06064beee068029ccb3"
    sha256 cellar: :any,                 mojave:         "f69c90ad1073fc0e2c485e6913d39178331ece8be30a737c9078ca152b1dfed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03b0098fe618d67cbfccaa6aa23d09b7d7f490e968f221122ebb2b4d14db3d0"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--mandir=#{man}",
                          "--disable-libwrap",
                          "--disable-systemd",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"

    # This programmatically recreates pem creation used in the tools Makefile
    # which would usually require interactivity to resolve.
    cd "tools" do
      system "dd", "if=/dev/urandom", "of=stunnel.rnd", "bs=256", "count=1"
      system "#{Formula["openssl@1.1"].opt_bin}/openssl", "req",
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

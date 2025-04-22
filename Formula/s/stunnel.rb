class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.74.tar.gz"
  sha256 "9bef235ab5d24a2a8dff6485dfd782ed235f4407e9bc8716deb383fc80cd6230"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3397dd9c588929b1c27eab79dfc68ac549154cc5723743860f3132a9eaa9b3e7"
    sha256 cellar: :any,                 arm64_sonoma:  "ed81eddd6dba1c5b0c530be48d7acc46e3a0a8312f9d5ae3d9118c0cd797533e"
    sha256 cellar: :any,                 arm64_ventura: "ac7f0bbfd5e4e7c5810d181b2ad929d5081d9d40714bb1638dc36149cb0574f4"
    sha256 cellar: :any,                 sonoma:        "82aa69de9ed3e96f6cf2b40a82ea5d725dc515f47a891649f9d49cb1371d0df4"
    sha256 cellar: :any,                 ventura:       "448441d68babf46d4b6c5f3feade07c6b24bacd6e6d3923c1b056fd1e6b118a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75643aec1f5929b9db2bb9a36b6a31ddd4fb205b67a97537c2bfe8eae4398806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c5735f96b3a3d61de2648205e462d3eded527d8480dc0dd026829aa3a9bbb03"
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

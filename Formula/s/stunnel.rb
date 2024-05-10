class Stunnel < Formula
  desc "SSL tunneling program"
  homepage "https://www.stunnel.org/"
  url "https://www.stunnel.org/downloads/stunnel-5.72.tar.gz"
  sha256 "3d532941281ae353319735144e4adb9ae489a10b7e309c58a48157f08f42e949"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.stunnel.org/downloads.html"
    regex(/href=.*?stunnel[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9355c18b5c774c0ebf38f7a72501d9ddd91aa9fb065a202cf8322897fc2f0ba"
    sha256 cellar: :any,                 arm64_ventura:  "6b8e8e41541437ede07271765721ad5c8ce63c41f00f1add95419a0b69b5d357"
    sha256 cellar: :any,                 arm64_monterey: "8e38c743381aa8118f34460c37e0bccf766da04aa6beb32965eda09a0be41d91"
    sha256 cellar: :any,                 sonoma:         "abbd7ba512fcbde3086d934910f8f1c851ea8b6d6d32d21fc1a4e80f4af962d7"
    sha256 cellar: :any,                 ventura:        "7d3b72c95f02663b5f0e51a2e19eff17b335bd5e474fb917f0b8574e7848c50c"
    sha256 cellar: :any,                 monterey:       "14e5adc675a656d7553ffcb537d38d1b6758382b33cebeb4ef57c7e0203755a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d725f644fbe330bf2938b8f243f0553b806bcb754ceff5248049adb5b8cc211"
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

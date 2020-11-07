class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.0.tar.gz"
  sha256 "5e407d684d0aa0919ddd15af368f890c5940cddd6034b7efc363823f38f6ff0c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "3477841d573b2612fff98a0dd1fa8ac46e3d43fdc110ddfd3767f6b433b344a4" => :catalina
    sha256 "822c56bfd75eccbdcc8a447236c996ca146e5efe324eea471dbbc212611dc0be" => :mojave
    sha256 "b11cef34c33d9f40ac677c034ff1557444d69735f3d5c88e8eaaffd135237d7d" => :high_sierra
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.2.0.tar.gz"
    sha256 "006ce4e1fa0786b1abfa18f675cd92f98558f612e6fde6fac8bd5a1e61b5e1c9"
    # https://sourceforge.net/p/ser2net/news/2020/10/gensio-220-and-ser2net-430-released/
    patch :DATA
  end

  def install
    resource("gensio").stage do
      system "./configure", "--with-python=no",
                            "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  plist_options manual: "ser2net -p 12345"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_sbin}/ser2net</string>
              <string>-p</string>
              <string>12345</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end


__END__
diff --git a/lib/gensio_sctp.c b/lib/gensio_sctp.c
index bd9437f..4278ff8 100644
--- a/lib/gensio_sctp.c
+++ b/lib/gensio_sctp.c
@@ -1092,7 +1092,7 @@ str_to_sctp_gensio_accepter(const char *str, const char * const args[],
 #else
 
 int
-sctp_gensio_alloc(struct gensio_addr *iai, const char * const args[],
+sctp_gensio_alloc(const struct gensio_addr *iai, const char * const args[],
 		  struct gensio_os_funcs *o,
 		  gensio_event cb, void *user_data,
 		  struct gensio **new_gensio)

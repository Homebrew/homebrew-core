class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.2.0.tar.gz"
  sha256 "1d895f005896e8c5bcff4fe573e2fec3611bf4feee1247857e476b74323d916c"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "c0133e4f6e044e683024ebf11fc81ceb6b38f19da808dea1b6aaa7219cfdf735" => :catalina
    sha256 "575504b003d96ed94cc054507cebdb89d8db23a381ff325e308c87fb49187079" => :mojave
    sha256 "3de3c5f9099400e4d4411c39ec33f959279c3d0c9ef03603f6b0128826070bcd" => :high_sierra
  end

  depends_on "libyaml"
  depends_on :macos => :sierra # needs clock_gettime

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.1.1.tar.gz"
    sha256 "e81df2c55d8830ac4f3c28eda54c3f690c4b62e186ea3879815b101a4902a703"

    # Pull request submitted upstream as https://github.com/cminyard/gensio/pull/19
    patch do
      url "https://github.com/cminyard/gensio/pull/19.patch?full_index=1"
      sha256 "2513ebcaf0395e59d846834eb59a5f0bacc077a0070bf9d1239ad223f16e6735"
    end
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

  plist_options :manual => "ser2net -p 12345"

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

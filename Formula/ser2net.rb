class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.2.1.tar.gz"
  sha256 "a0d84c71a6bc75d73737461708f964084c6bbfe0cc1ef4725b4cd9cc35de14c0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "ae75303b4163f8f89366652ef7fafea5af5e158cb8f38b60ba11d71802f5b437" => :catalina
    sha256 "05f13e77292479fa8f605d854fe853d57b078b3afee2038c1bdf12470e670664" => :mojave
    sha256 "5888f6158084ff46d3d863ad468dd0a776bc84116a7100a85e5b9fbbfc781291" => :high_sierra
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.1.4.tar.gz"
    sha256 "1f5a29aabfb35886893cfda5cd78192db67e96de796dbf9758dbecd4077a3fd8"
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

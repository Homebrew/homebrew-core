class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.1.8.tar.gz"
  sha256 "cffb5147021202b064eb0a9389d0db63d1bb2dcde5a896f7785f97b1b5f51a72"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "212684df3012508da810e7cd273f1418debf734aacb39949b54aca7b592b1a76" => :catalina
    sha256 "83435a03046d3e3db9461ae4dcf9357f6809290bf91560f2f3d722cac22ee6ce" => :mojave
    sha256 "9be8a962e23275a1400a60f94b5e98fc311cf9c917320b5c03d13edcebe40f67" => :high_sierra
    sha256 "8b4c2e80e4fd884c9761a18684191f5d508c858330989a492922fdb231e1ea5d" => :sierra
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

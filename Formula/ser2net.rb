class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.2.0.tar.gz"
  sha256 "1d895f005896e8c5bcff4fe573e2fec3611bf4feee1247857e476b74323d916c"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "1f7cee8eefe4625bd2c75f48f3b1386dd61379b6b81b21b57c1792b0a246a8f1" => :catalina
    sha256 "f8a9cc43919eeae9ebbbfc91a5b463f2f95fe0f312724cc1555038a4ef423f93" => :mojave
    sha256 "32df43b370d1da50357d2890c65f57c228a9352272b2ca462728183801db917f" => :high_sierra
  end

  depends_on "libyaml"
  depends_on :macos => :sierra # needs clock_gettime

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.1.1.tar.gz"
    sha256 "e81df2c55d8830ac4f3c28eda54c3f690c4b62e186ea3879815b101a4902a703"

    # Pull request submitted upstream as https://github.com/cminyard/gensio/pull/19
    patch do
      url "https://github.com/cminyard/gensio/commit/9ac32a1e0adc314b54d333f96522ec41234b8714.patch?full_index=1"
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

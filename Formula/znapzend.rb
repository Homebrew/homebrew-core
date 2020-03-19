class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.19.1/znapzend-0.19.1.tar.gz"
  sha256 "93e3ec3c6f5cdf6973f72a6b764c49dc6545f2a0a2e0267a1382d471b930efea"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d52960b6314938d41a65d7b441c3a6c8ef211cd1ca5e7388b59af0a92cb61b7" => :catalina
    sha256 "7962667b10e7f44b35469d4b5ef1a8e4aeaf75310b34e72840edfc283f1aae16" => :mojave
    sha256 "7fca9b0f4b129afbc30bee164b1a73911e4da9e48c4943b1d6e7e8e77a1cec17" => :high_sierra
    sha256 "f12ede845017559f77147ceab275fcbb128f3bdec7a1ff0cd72d54029349a419" => :sierra
    sha256 "d88080d21fd9def227853fc0d08db6bef5a10d0bca74c16c0207f023aabc8d67" => :el_capitan
  end

  depends_on "perl" if MacOS.version == :mavericks

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var/"log/znapzend").mkpath
    (var/"run/znapzend").mkpath
  end

  plist_options :startup => true, :manual => "sudo znapzend --daemonize"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/znapzend</string>
            <string>--connectTimeout=120</string>
            <string>--logto=#{var}/log/znapzend/znapzend.log</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/znapzend/znapzend.err.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/znapzend/znapzend.out.log</string>
          <key>ThrottleInterval</key>
          <integer>30</integer>
          <key>WorkingDirectory</key>
          <string>#{var}/run/znapzend</string>
        </dict>
      </plist>
    EOS
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~EOS
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end

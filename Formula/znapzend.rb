class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.20.0/znapzend-0.20.0.tar.gz"
  sha256 "c0a1ab9df5d6c4936560b5f8f08d393d4e99313da190fa404cd8ee5df420a7ca"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37b73cba5b7ed887b1e72175d3c601c08e449ed3bbcaa87668641704477889d1" => :catalina
    sha256 "9a508c6a3fb15609b3552ce38369b16664f08515f635bd8a3dc92ed79d17d381" => :mojave
    sha256 "18e1269f3ab2964382c1cc7578fa8785ee7ba1412a1c247861d76accde2a6cc5" => :high_sierra
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

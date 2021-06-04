class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/6.0.3/questdb-6.0.3-no-jre-bin.tar.gz"
  sha256 "426c826b1e058241789114a0a77ee0723c886e9d5b248e4467960fc256001e00"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk@11"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env("11")
  end

  plist_options manual: "questdb start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/questdb</string>
            <string>start</string>
            <string>-d</string>
            <string>var/"questdb"</string>
            <string>-n</string>
            <string>-f</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}/questdb</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/questdb.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/questdb.log</string>
          <key>SoftResourceLimits</key>
          <dict>
            <key>NumberOfFiles</key>
            <integer>1024</integer>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    mkdir_p testpath/"data"
    begin
      fork do
        exec "#{bin}/questdb start -d #{testpath}/data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system "#{bin}/questdb", "stop"
    end
  end
end

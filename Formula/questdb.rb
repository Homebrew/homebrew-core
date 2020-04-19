class Questdb < Formula
  desc "Time Series Database"
  homepage "https://www.questdb.io"
  url "https://github.com/questdb/questdb/releases/download/4.2.0/questdb-4.2.0-bin.tar.gz"
  sha256 "6e262f3f987c37636e0a92eb62291c395d5e215fad61fe885c7bcb2d54b6d720"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/questdb.sh" => "questdb"
  end

  plist_options :manual => "questdb start"

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
        exec "#{bin}/questdb start -d  #{testpath}/data"
      end
      sleep 4
      output = shell_output("curl -Is localhost:9000/js?q=x")
      sleep 4
      assert_match /questDB/, output
    ensure
      system "#{bin}/questdb", "stop"
    end
  end
end

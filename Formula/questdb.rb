class Questdb < Formula
  desc "Time Series Database"
  homepage "https://www.questdb.org"
  url "https://www.questdb.org/download/questdb-1.0.0-SNAPSHOT-20161013-1304-bin.tar.gz"
  sha256 "66f4d43868e8d0eb61606712a25f397023c82e368bbcbfda7cc007611661984b"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/questdb.sh" => "questdb"
  end

  plist_options :manual => "questdb start"

  def plist; <<-EOS.undent
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
        system "#{bin}/questdb", "start", "-d", "#{testpath}/data"
        sleep 2
        output = shell_output("curl -Is localhost:9000/js?q=x")
        sleep 1
        assert_match /questDB/, output
    ensure
        system "#{bin}/questdb", "stop"
    end
  end
end

class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/6.1.3/questdb-6.1.3-no-jre-bin.tar.gz"
  sha256 "3d1c7031c0fd80560597f8ce64cbc6cd8a3097e80f7cfb94581189bdc5d04834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed3f10447f582b734c2e053990abc117e28854637bace0488a590a652938b6b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf42676e75b468303fc50faa639ffe8c16e98dd6d1da57f5e523e3cea3a1e43c"
    sha256 cellar: :any_skip_relocation, catalina:      "bf42676e75b468303fc50faa639ffe8c16e98dd6d1da57f5e523e3cea3a1e43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3f10447f582b734c2e053990abc117e28854637bace0488a590a652938b6b9"
  end

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

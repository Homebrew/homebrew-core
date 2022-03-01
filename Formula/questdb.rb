class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/6.2.1/questdb-6.2.1-no-jre-bin.tar.gz"
  sha256 "607d95346841846e015e6723af25b4047dc1acdf1912d0a259ffff15c314b93e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da206250457617c9f6f09c3547387ddcaf5c41f83a1c37ed6b3730e3841e67eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "6973a33e0a58de33d278b26f7996b51348d400724b3c6cec16b7efa65d4d7bdb"
    sha256 cellar: :any_skip_relocation, catalina:      "6973a33e0a58de33d278b26f7996b51348d400724b3c6cec16b7efa65d4d7bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da206250457617c9f6f09c3547387ddcaf5c41f83a1c37ed6b3730e3841e67eb"
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

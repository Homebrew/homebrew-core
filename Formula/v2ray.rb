class V2ray < Formula
  desc "Project V provide a unified platform for anti-censorship"
  homepage "https://github.com/v2ray/v2ray-core"
  version "4.22.1"
  url "https://github.com/v2ray/v2ray-core/archive/v#{version}.tar.gz"
  sha256 "31c1934eeac3552c7ab68eac9dc3e964e05f3c743b3733b0b6a0159c495019d6"

  depends_on "go" => :build
  depends_on "geoip"

  resource "geosite" do
    url "https://github.com/v2ray/domain-list-community/releases/download/202001070832/dlc.dat"
    sha256 "f58fa04f8c943584a3b3ffc5678f1dc27abc429a9ff600868ba97f313938f2e9"
  end
  resource "geoip" do
    url "https://github.com/v2ray/geoip/releases/download/202001070102/geoip.dat"
    sha256 "434d3f415655baa2e991a78786defe5dff798f245445cfe4580ac5d6a4a3eecf"
  end

  def install
    ENV.append "CGO_ENABLED", 0
    ldflags = "-s -w -X v2ray.com/core.codename=homebrew -X v2ray.com/core.build=#{DateTime.now.strftime("%Y%m%d-%H%M%S")} -X v2ray.com/core.version=#{version}"
    system "go", "build", "-o", "#{bin}/#{name}", "-ldflags", "'#{ldflags}'", "./main"
    system "go", "build", "-o", "#{bin}/v2ctl", "-ldflags", "'#{ldflags}'", "./infra/control/main"
    rm  "release/config/geoip.dat"
    rm  "release/config/geosite.dat"
    rm_rf "release/config/systemv"
    rm_rf "release/config/systemd"
    etc.install "release/config" => "v2ray"

    resource("geosite").stage do
      rm "#{etc}/v2ray/geosite.dat"
      (etc/"v2ray").install "dlc.dat" => "geosite.dat"
    end
    resource("geoip").stage do
      rm "#{etc}/v2ray/geoip.dat"
      (etc/"v2ray").install "geoip.dat"
    end
  end

  plist_options :manual => "v2ray"
  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnvironmentVariables</key>
      <dict>
        <key>V2RAY_LOCATION_ASSET</key>
        <string>#{etc}/v2ray</string>
      </dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/v2ray</string>
        <string>-config</string>
        <string>#{etc}/v2ray/config.json</string>
        <string>-format=json</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>/tmp</string>
    </dict>
    </plist>
  EOS
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/v2ray", "-test -config #{etc}/v2ray/config.json") do |_, stdout, _|
      assert_equal "result", stdout.read
    end
  end
end

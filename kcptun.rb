class Kcptun < Formula
  desc "extremely simple & fast udp tunnel based on kcp protocol"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun.git",
    :tag => "v20160701", :revision => "13e980cdffb02e0b2bc793366e1314e663f549fc"

  head "https://github.com/xtaci/kcptun.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/".kcptun-gopath"
    mkdir_p buildpath/".kcptun-gopath/src/github.com/xtaci"
    cp_r cached_download, buildpath/".kcptun-gopath/src/github.com/xtaci/kcptun"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    cd buildpath/".kcptun-gopath/src/github.com/xtaci/kcptun"
    system "go", "get", "-v", "./client"
    system "go", "build", "-ldflags", "-X main.VERSION=20160701 -s -w", "-o", "kcptun_client", "github.com/xtaci/kcptun/client"
    bin.install "kcptun_client"
    (bin/"kcptun").write <<-EOS.undent
        #!/bin/sh
        #{bin}/kcptun_client -r serverip:554 -l 127.0.0.1:1080 -mode fast2
    EOS
  end

  def caveats; <<-EOS.undent
    Now, you can use kcptun_client and kcptun (with config).
    But if you want to use kcptun, you must modify it's config first.
        vim #{opt_bin}/kcptun
    Config example:
        server: ./server_linux_amd64 -t 127.0.0.1:1080 -l :554 -mode fast2
        client: ./client_darwin_amd64 -r serverip:554 -l :1080 -mode fast2
    EOS
  end

  plist_options :manual => "kcptun"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/kcptun</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>Crashed</key>
          <true/>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kcptun.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kcptun.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match "kcptun version", shell_output("#{opt_bin}/kcptun_client -v")
  end
end

class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://filippo.io/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/v0.1.3.tar.gz"
  sha256 "58c597551daf0c429d7ea63f53e72b464f8017f5d7f88965d4dae397ce2cb70a"
  license "BSD-3-Clause"
  head "https://filippo.io/yubikey-agent", using: :git

  depends_on "go" => :build
  depends_on "pinentry-mac"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=v#{version}"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
        export SSH_AUTH_SOCK="#{var}/run/yubikey-agent.sock"
    EOS
  end

  plist_options manual: "yubikey-agent -l #{HOMEBREW_PREFIX}/var/run/yubikey-agent.sock"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{Formula["pinentry-mac"].opt_bin}</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/yubikey-agent</string>
          <string>-l</string>
          <string>#{var}/run/yubikey-agent.sock</string>
        </array>
        <key>RunAtLoad</key><true/>
        <key>KeepAlive</key><true/>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/yubikey-agent.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/yubikey-agent.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    socket = testpath/"yubikey-agent.sock"
    fork { exec bin/"yubikey-agent", "-l", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end

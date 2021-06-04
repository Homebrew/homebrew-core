class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://filippo.io/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/v0.1.4.tar.gz"
  sha256 "797377b0781ccd4acf390cb13814d5fab653afd7b5a7eff226137f5f1503709b"
  license "BSD-3-Clause"
  head "https://filippo.io/yubikey-agent", using: :git

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "950c6257f3a78028a23798ec38fc13b21b70c7995246d6bce8ab142b0467014f"
    sha256 cellar: :any_skip_relocation, big_sur:       "c039d2e64526ae2c7e488cdcf5c104579fecd447886cc857892c1efd28bf7b63"
    sha256 cellar: :any_skip_relocation, catalina:      "41bfe241c1ee1424ccee14ba04b583c71cb0dbf481db311fd1f12f552258f941"
    sha256 cellar: :any_skip_relocation, mojave:        "4ec8a15bca487e38310100533e787d8e7bcc80ab9f6d4285f49f9df58fbee5b3"
  end

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

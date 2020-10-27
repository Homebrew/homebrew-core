class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.1.6.tar.gz"
  sha256 "5ddd6ad256ba9add7792d239a7f8a45c68c2f02770ed788da3132ee933e3962e"
  license "MIT"
  head "https://github.com/semihalev/sdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3adab56dd15cdc30a5ece4f24a7c2ef3900cc1ae779660609885ecbe9c9add0" => :catalina
    sha256 "6bed2b4a199ac0851bc2afd974013245c7b9625a40b25db03a6d08344867f37e" => :mojave
    sha256 "6ba4e92207324f66de1bcff838fe1898f057d102d076568c18c842afbeb717aa" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/sdns</string>
            <string>-config</string>
            <string>#{etc}/sdns.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>WorkingDirectory</key>
          <string>#{opt_prefix}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end

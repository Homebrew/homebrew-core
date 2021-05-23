class TrustDns < Formula
    desc "A Rust based DNS client, server, and resolver "
    homepage "https://github.com/bluejekyll/trust-dns"
    url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.20.3.tar.gz"
    sha256 "1766f59ea28e1c1289fcd370d455ae73416814035bad1de313528391cbf8454a"
    license "MIT"

    bottle do
      sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a11932b3795555ff253f46390d64d6926c9603883929c8b5dcc07ed5dfd7f9e"
      sha256 cellar: :any_skip_relocation, big_sur:       "460853143bb40faf7de7d49c64616d4eeea29b0de22e9c153f31af3f7c1605db"
      sha256 cellar: :any_skip_relocation, catalina:      "0e9069d562ca1b387472e961493b8cc6f962bfa81d8de3cc86f06bc40bcd4d85"
      sha256 cellar: :any_skip_relocation, mojave:        "1a6342771b768a51b042f1978b360a374cec75ac4ed2a9dd7317db6aff552127"
    end

    depends_on "rust" => :build

    uses_from_macos "zlib"

    def install
      system "cargo", "install", "--all-features", std_cargo_args[0], std_cargo_args[1], std_cargo_args[2], std_cargo_args[3],"./util"
      system "cargo", "install", "--all-features", std_cargo_args[0], std_cargo_args[1], std_cargo_args[2], std_cargo_args[3],"./bin"
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
              <string>#{opt_bin}/named</string>
              <string>-c</string>
              <string>#{etc}/named.toml</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>#{var}/log/trust-dns.log</string>
            <key>StandardOutPath</key>
            <string>#{var}/log/trust-dns.log</string>
            <key>WorkingDirectory</key>
            <string>#{HOMEBREW_PREFIX}</string>
          </dict>
        </plist>
      EOS
    end

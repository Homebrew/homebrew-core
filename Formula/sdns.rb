class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.1.8.tar.gz"
  sha256 "9b5ca516e711764ba1e840e97b679ef3d299c60945920b84baed155fb8df8711"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21793de02e83d10ac51abae2ba85addcbac395b39ee37fc41ca8847974eec92b"
    sha256 cellar: :any_skip_relocation, big_sur:       "82ae1e7bea85f50fcf84de51fb0fb790faf88d0cefaf8532f587047e8fe842a5"
    sha256 cellar: :any_skip_relocation, catalina:      "b1dd23b40afd486a0343af0b6e2b738d5c4a19869484e01de28889e7abc6ae5b"
    sha256 cellar: :any_skip_relocation, mojave:        "aa9dd1a91d45ddcc4574ca51084f6d57885541d6e495230e2870e60bf1d2395a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f8696ee4f9832f746ef504e348b1c3e45eefa15101b25e00e9c7102d3defac"
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

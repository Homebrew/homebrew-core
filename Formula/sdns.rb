class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.1.8.tar.gz"
  sha256 "5ffc8a72be67c3f9ce7200fd638ade6435ae177b09eda5eb149daadc66955ba6"
  license "MIT"
  revision 1
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31d37bbf975d52771e264b5525901451f4c8ab07699f748765f01ac66a97815e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed0799e9fe671a1f83413865e3edd17c91e7be25cbb3750a1ffd192f1cc5e8b3"
    sha256 cellar: :any_skip_relocation, catalina:      "743eb7d702801e6f8f9955b39d5ade0910c62f2146b9654af70ea811ab296db2"
    sha256 cellar: :any_skip_relocation, mojave:        "efd45f52f39c3a66c4ef269ecb0149d563ec3f3ce983b95cf9c3ebfc12cf41f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b904e1cec53ae97198d246cc6b2d518cdf0e357e3988ad7d40007a2979938243"
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

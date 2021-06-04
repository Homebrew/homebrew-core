class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.4.0.tar.gz"
  sha256 "e7035a8a40913614f4ab24d7caad2c26419fd2b0aaa3565c16439e59214ae590"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ae9cb66b55b3608fc796e17f722da433461c6725ce5d5e63d0260a576cfe08a"
    sha256 cellar: :any_skip_relocation, big_sur:       "53d35518fa3e7f5d671ac4841553d1df38c613f5634fc4d0e2962280c8ec7328"
    sha256 cellar: :any_skip_relocation, catalina:      "c43b04d0dbd41086de940ca96f4da40b907a517ff17c83e984569e888aff2448"
    sha256 cellar: :any_skip_relocation, mojave:        "5116f00b9e4666ba6059123d0632e118bd217d95c10d7e2a507c42ed8b1600ce"
  end

  depends_on "go" => :build

  resource "sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/master/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    system "go", "build", *std_go_args,
      "-ldflags", "-X github.com/zrepl/zrepl/version.zreplVersion=#{version}"
  end

  def post_install
    (var/"log/zrepl").mkpath
    (var/"run/zrepl").mkpath
    (etc/"zrepl").mkpath
  end

  plist_options startup: true, manual: "sudo zrepl daemon"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/zrepl</string>
            <string>daemon</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/zrepl/zrepl.err.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/zrepl/zrepl.out.log</string>
          <key>ThrottleInterval</key>
          <integer>30</integer>
          <key>WorkingDirectory</key>
          <string>#{var}/run/zrepl</string>
        </dict>
      </plist>
    EOS
  end

  test do
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      assert_equal "", shell_output("#{bin}/zrepl configcheck --config #{r.cached_download}")
    end
  end
end

class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.3.0.tar.gz"
  sha256 "669b59ca524f487a76145f7153b9c048442cd1b96a293e0dc18048f5024a2997"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "089ca444325890a214face9ea6de0cfc7de1a931ce126e4253f0c390c814fd67" => :catalina
    sha256 "0907d294ed2efe16891751914c03f869940b0c640e82ae11b882d50a60352dab" => :mojave
    sha256 "d480d224d1cfd259622de17f60d7f619f439e9cf37337a0a136fba827daa36d2" => :high_sierra
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

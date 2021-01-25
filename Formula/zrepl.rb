class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.3.1.tar.gz"
  sha256 "46c4540c330ec68f30eafa9c44f27bfc04fcac85a2fe54b72b051c73cd11f66d"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04ba02a1867bf19002e289edbf40423a3eb1a95fea05ae813b1cff5fc71d3873" => :big_sur
    sha256 "5b7ea253b2d72f513eeae44b390feed827cb09bed8dfe2df97500e0d269017d8" => :arm64_big_sur
    sha256 "1314da8c7c65f89c93a17ca3dab945e0132e61a1e5cc2ec83f3e844bb1a475fc" => :catalina
    sha256 "d4c76f92429aea1e62be4e187f263c478b60ab47bbd739d4c97f97fd3d852dab" => :mojave
    sha256 "bf399e30a67a4cab316128ef33b9e1349bb51a32a0c6befeecb79ef2837c22b5" => :high_sierra
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

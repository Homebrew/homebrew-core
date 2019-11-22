class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.2.0.tar.gz"
  sha256 "40ceb559059b43e96f61303a43ca0fac80b26f8281a07aa03e235658a6548891"
  head "https://github.com/zrepl/zrepl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb99b7814e895f3004274ef6898002a2f09a8a88948a3a3fd79810adedf29beb" => :catalina
    sha256 "ad08b412021d906160358c211cf6f9a8578f82a427610f576e206d2424dbc2f8" => :mojave
    sha256 "51b266e1b03634d565d898848b20b6a7c1267dfac0ab3cfe7d0a1f011f6b46c5" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  resource "sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/master/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/zrepl/zrepl").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"
    cd gopath/"src/github.com/zrepl/zrepl" do
      system "go", "build", "-o", "'$GOPATH/bin/stringer'", "golang.org/x/tools/cmd/stringer"
      system "go", "build", "-o", "'$GOPATH/bin/protoc-gen-go'", "github.com/golang/protobuf/protoc-gen-go"
      system "go", "build", "-o", "'$GOPATH/bin/enumer'", "github.com/alvaroloes/enumer"
      system "go", "build", "-o", "'$GOPATH/bin/goimports'", "golang.org/x/tools/cmd/goimports"
      system "go", "build", "-o", "'$GOPATH/bin/golangci-lint'", "github.com/golangci/golangci-lint/cmd/golangci-lint"
      system "make", "ZREPL_VERSION=#{version}"
      bin.install "artifacts/zrepl"
    end
  end

  def post_install
    (var/"log/zrepl").mkpath
    (var/"run/zrepl").mkpath
    (etc/"zrepl").mkpath
  end

  plist_options :startup => true, :manual => "sudo zrepl daemon"

  def plist; <<~EOS
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
